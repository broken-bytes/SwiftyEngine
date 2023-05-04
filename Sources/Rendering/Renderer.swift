import Core
import Foundation
import SDL
import ShaderCompiler
import Vulkan

public class Renderer {

    public static let shared = Renderer()
    private var shaderCompiler: ShaderCompiler!
    private var vkInstance: UnsafeMutablePointer<VkInstance?>!
    private var surface: UnsafeMutablePointer<VkSurfaceKHR?>!
    private var device: Device!
    private var width: Int32 = 0
    private var height: Int32 = 0
    private var swapchain: Swapchain!
    private var mainQueue: Queue!
    private var renderFence: Fence!
    private var presentSemaphore: Semaphore!
    private var renderSemaphore: Semaphore!
    private var commandPool: CommandPool!
    private var mainCommandBuffer: CommandBuffer!
    private let frameBufferCount: UInt8 = 2

    private var mainRenderPass: RenderPass!
    private var frameBuffers: [FrameBuffer] = []

    private var drawCalls: [DrawCall] = []
    private var pipelines: [Pipeline] = []
    private var shaders: [Shader] = []
    private var materials: [Material] = []
    private var meshes: [Mesh] = []

    internal init() {}

    public func bind(to window: Window) {
        surface = .allocate(capacity: 1)
        vkInstance = .allocate(capacity: 1)
        initInstance(window: window)
        initDevice()
        shaderCompiler = ShaderCompiler(device: device)
        sdlHandleSafe(SDL_Vulkan_CreateSurface(window.windowPtr, vkInstance?.pointee, surface))
        initQueues()
        initSwapchain(window: window)
        renderFence = Fence(device: device)
        presentSemaphore = Semaphore(device: device)
        renderSemaphore = Semaphore(device: device)
        initRenderPasses()
        initBuffers()
    }

    public func update() {
        
    }

    public func createMaterial(vertexShaderId: UInt32, pixelShaderId: UInt32) -> UInt32 {

        var pipeline = pipelines.first { 
            $0.vertexShader.id == vertexShaderId && $0.pixelShader.id == pixelShaderId 
        }

        guard
            let vs = shaders.first(where: { $0.id == vertexShaderId }),
            let ps = shaders.first(where: { $0.id == pixelShaderId })
        else { 
            fatalError("Shaders not found")
        }

        if pipeline == nil {
            let newPipeline = Pipeline(device: device, vertexShader: vs, pixelShader: ps, renderPass: mainRenderPass)
            pipelines.append(newPipeline)
            pipeline = newPipeline
        }

        guard let pipeline else {
            fatalError("Created Pipeline is nil")
        }
        
        let material = Material(vertexShader: vs, pixelShader: ps, pipeline: pipeline)
        materials.append(material)

        return material.id
    }

    public func render() {
        renderFence.wait()
        renderFence.reset()

        var swapchainImageIndex: UInt32 = 0
	    vkHandleSafe(vkAcquireNextImageKHR(device.device, swapchain.vkSwapchain, 1000000000, presentSemaphore.vkSemaphore, nil, &swapchainImageIndex))
        mainCommandBuffer.reset()

        mainCommandBuffer.execute(
            framebuffer: frameBuffers[Int(swapchainImageIndex)], 
            renderPass: mainRenderPass,
            extent: VkExtent2D(width: UInt32(width), height: UInt32(height))
        ) { 
            $0.set(clearColor: .init(color: .init(float32: (0.1, 0.1, 0.2, 1))))
            $0.set(viewport: Viewport(x: 0, y: 0, width: UInt32(self.width), height: UInt32(self.height)))

            for drawcall in self.drawCalls {
                // First check if it a fullscreen effect
                if !drawcall.isFullscreenEffect {
                    if !drawcall.isCommand {
                        guard let meshDrawCall = drawcall as? MeshDrawCall else {
                            continue
                        }

                        guard 
                            let material = self.materials.first(where: { $0.id == meshDrawCall.materialId }),
                            let mesh = self.meshes.first(where: { $0.id == meshDrawCall.meshId })
                        else {
                            continue
                        }

                        $0.bind(to: material.pipeline)
                        $0.bind(to: mesh.vertexBuffer)
                        $0.draw(numVertices: mesh.vertexBuffer.count, numInstaces: 1, offset: 0, firstInstance: 0)  
                    }
                }

            }
        }

        mainQueue.submit(
            renderSemaphore: &renderSemaphore, 
            presentSemaphore: &presentSemaphore, 
            commandBuffers: [mainCommandBuffer],
            fence: renderFence
        )

        mainQueue.present(
            swapchain: swapchain,
            renderSemaphore: &renderSemaphore, 
            swapchainImageIndex: &swapchainImageIndex
        )

        drawCalls = []
    }

    public func execute(drawCall: DrawCall) {
        drawCalls.append(drawCall)
        drawCalls.sort(by: { $0.key < $1.key })
    }

    public func compileShader(at path: String) -> UInt32 {
        let shader = try! shaderCompiler.compile(at: path)
        shaders.append(shader)
        log(level: .info, message: "Shader: \(shader)")

        return shader.id
    }

    public func uploadImage() -> Void {
        
    }

    public func uploadMesh(mesh: MeshData) -> UInt32 {
        let vertBuffer = device.createVertexBuffer(with: mesh.vertices)
        let indexBuffer = device.createIndexBuffer(with: mesh.indices)

        let mesh = Mesh(vertexBuffer: vertBuffer, indexBuffer: indexBuffer)
        meshes.append(mesh)

        return mesh.id
    }
}

// MARK: Create extension
extension Renderer {

    private func createPipeline(vertexShader: Shader, pixelShader: Shader) -> UInt32 {
        let pipeline = Pipeline(device: device, vertexShader: vertexShader, pixelShader: pixelShader, renderPass: mainRenderPass)
        pipelines.append(pipeline)

        return pipeline.id
    }
}

// MARK: Initialiser extension
extension Renderer {

    private func initInstance(window: Window) {
        var app = VkApplicationInfo()

        "Kyanite".withCString {
            app.pEngineName = $0
        }
        "Game".withCString {
            app.pApplicationName = $0
        }

        app.apiVersion = 0
        app.applicationVersion = 1
        app.engineVersion = 1
        app.sType = VK_STRUCTURE_TYPE_APPLICATION_INFO

        var sdlExtCount: UnsafeMutablePointer<UInt32> = .allocate(capacity: 1)
        SDL_Vulkan_GetInstanceExtensions(window.windowPtr, sdlExtCount, nil)

        var sdlExts: UnsafeMutablePointer<UnsafePointer<CChar>?> = .allocate(capacity: Int(sdlExtCount.pointee))
        SDL_Vulkan_GetInstanceExtensions(window.windowPtr, sdlExtCount, sdlExts)
        var infoPtr = UnsafeMutablePointer<VkApplicationInfo>.allocate(capacity: 1)
        infoPtr.initialize(to: app)

        var info = VkInstanceCreateInfo(
            sType: VK_STRUCTURE_TYPE_INSTANCE_CREATE_INFO, 
            pNext: nil, 
            flags: 0, 
            pApplicationInfo: infoPtr, 
            enabledLayerCount: 0, 
            ppEnabledLayerNames: nil,
            enabledExtensionCount: sdlExtCount.pointee, 
            ppEnabledExtensionNames:  UnsafePointer<UnsafePointer<CChar>?>(sdlExts)
        )

        vkHandleSafe(vkCreateInstance(&info, nil, vkInstance))

        SDL_Vulkan_GetDrawableSize(window.windowPtr, &width, &height)

        log(level: .info, message: "Instance - Created")
    }

    private func initDevice() {
        let gpu = findBestGPU()

        var props: UnsafeMutablePointer<VkPhysicalDeviceProperties> = .allocate(capacity: 1)
        vkGetPhysicalDeviceProperties(gpu, props)

        let rawPtr = UnsafeMutableRawPointer(mutating: props)
        let namePtrRaw = rawPtr
            // apiVersion
            .advanced(by: 4)
            // driverVersion
            .advanced(by: 4)
            // vendorId
            .advanced(by: 4)
            // deviceId
            .advanced(by: 4)
            // deviceType
            .advanced(by: 4)

        let namePtr = namePtrRaw.bindMemory(to: CChar.self, capacity: Int(VK_MAX_PHYSICAL_DEVICE_NAME_SIZE))

        let name = String.init(cString: namePtr)
        self.device = Device(physicalDevice: gpu, name: name)
        log(level: .info, message: "Device - Created")
    }

    private func initQueues() {
        mainQueue = Queue(device: device, familyIndex: 0)
        commandPool = CommandPool(device: device, familyIndex: 0)
        mainCommandBuffer = CommandBuffer(device: device, commandPool: commandPool)
        log(level: .info, message: "Queues - Created")
    }

    private func initSwapchain(window: Window) {
        self.swapchain = Swapchain(width: UInt32(width), height: UInt32(height), device: device, surface: surface, buffers: frameBufferCount, imageFormat: VK_FORMAT_B8G8R8A8_SRGB)
        log(level: .info, message: "Swapchain - Created")
    }

    private func initRenderPasses() {
        mainRenderPass = RenderPass(
            device: device, 
            format: swapchain.imageFormat, 
            samples: 1, 
            useStencil: false,
            usedForPresenting: true
        )
        log(level: .info, message: "Render Passes - Created")
    }

    private func initBuffers() {
        for x in 0..<frameBufferCount {
            let buffer = FrameBuffer(
                device: device, 
                width: UInt32(width), 
                height: UInt32(height), 
                renderPass: mainRenderPass,
                imageView: swapchain.imageViews[Int(x)]
            )
            frameBuffers.append(buffer)
        }
        log(level: .info, message: "Buffers - Created")
    }

    private func findBestGPU() -> VkPhysicalDevice {
        var count: UnsafeMutablePointer<UInt32> = .allocate(capacity: 1)
        vkEnumeratePhysicalDevices(vkInstance?.pointee, count, nil)

        var devices: UnsafeMutableBufferPointer<VkPhysicalDevice?> = .allocate(capacity: Int(count.pointee))
        vkEnumeratePhysicalDevices(vkInstance?.pointee, count, devices.baseAddress)

        var selectedGPU: VkPhysicalDevice?
        var gpuType: VkPhysicalDeviceType = VK_PHYSICAL_DEVICE_TYPE_OTHER

        for device in devices {
            guard let device else { continue }

            var props: UnsafeMutablePointer<VkPhysicalDeviceProperties> = .allocate(capacity: 1)
            vkGetPhysicalDeviceProperties(device, props)

            if selectedGPU == nil {
                selectedGPU = device
                gpuType = props.pointee.deviceType

                continue
            }

            // Ranking:
            // - 2 Discrete GPU
            // - 1 Integrated GPU
            // - 3 Virtual GPU
            // - 4 CPU
            // - 0 Other


            if props.pointee.deviceType == VK_PHYSICAL_DEVICE_TYPE_DISCRETE_GPU { 
                // If we found a discrete GPU already we ignore the next ones
                if gpuType != VK_PHYSICAL_DEVICE_TYPE_DISCRETE_GPU {
                    selectedGPU = device
                    gpuType = props.pointee.deviceType
                }
            } else if props.pointee.deviceType == VK_PHYSICAL_DEVICE_TYPE_INTEGRATED_GPU  { 
                // If the current selected GPU is not discrete we select this one
                if gpuType != VK_PHYSICAL_DEVICE_TYPE_DISCRETE_GPU {
                    selectedGPU = device
                    gpuType = props.pointee.deviceType
                }
            } else if props.pointee.deviceType == VK_PHYSICAL_DEVICE_TYPE_VIRTUAL_GPU {
                // If we do not have a discrete or iGPU we use the virtual one
                if gpuType != VK_PHYSICAL_DEVICE_TYPE_DISCRETE_GPU && gpuType != VK_PHYSICAL_DEVICE_TYPE_DISCRETE_GPU {
                    selectedGPU = device
                    gpuType = props.pointee.deviceType
                }
            } else {
                // Only use other or cpu when no otehr type was found before
                if gpuType != VK_PHYSICAL_DEVICE_TYPE_DISCRETE_GPU && gpuType != VK_PHYSICAL_DEVICE_TYPE_DISCRETE_GPU && gpuType != VK_PHYSICAL_DEVICE_TYPE_VIRTUAL_GPU {
                    selectedGPU = device
                    gpuType = props.pointee.deviceType
                }
            }
        }

        guard let selectedGPU else {
            fatalError("No GPU found")
        }

        return selectedGPU
    }
}