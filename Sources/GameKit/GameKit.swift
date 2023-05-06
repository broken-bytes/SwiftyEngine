import Audio
import Core
import Foundation
import ECS
import Rendering

fileprivate var meshId: UInt32!
fileprivate var materialId: UInt32!

public class GameKit {

    public static let shared = GameKit()

    private var mainWindow: Window!

    private init() {
        initLogger()
        mainWindow = WindowManager.shared.makeWindow(width: 1200, height: 800, named: "MainWindow")
        Renderer.shared.bind(to: self.mainWindow)

        signal(SIGABRT) { 
            log(level: .error, message: "\($0)")
        }

        signal(SIGSEGV) { 
            log(level: .error, message: "\($0)")
        }

        signal(SIGILL) { 
            log(level: .error, message: "\($0)")
        }

        signal(SIGTERM) { 
            log(level: .error, message: "\($0)")
        }

        signal(SIGBREAK) { 
            log(level: .error, message: "\($0)")
        }

        let vertexShader = Renderer.shared.compileShader(at: "H:/Projects/SwiftTest/Compiled/Shaders/default.vs.spv")
        let pixelShader = Renderer.shared.compileShader(at: "H:/Projects/SwiftTest/Compiled/Shaders/default.ps.spv")
        let material = Renderer.shared.createMaterial(vertexShaderId: vertexShader, pixelShaderId: pixelShader)

        let vertices: [Vertex] = [
            Vertex(
                position: Vector3(x: 0, y: -0.5, z: 0),
                uv: Vector2(x: 0, y: 0),
                color: Color(r: 0, g: 1, b: 1, a: 1)
            ),
            Vertex(
                position: Vector3(x: 0.5, y: 0.5, z: 0),
                uv: Vector2(x: 0, y: 0),
                color: Color(r: 1, g: 1, b: 1, a: 1)
            ),
            Vertex(
                position: Vector3(x: -0.5, y: 0.5, z: 0),
                uv: Vector2(x: 0, y: 0),
                color: Color(r: 1, g: 1, b: 0, a: 1)
            ),
        ]

        let mesh = MeshData(vertices: vertices, indices: [0])

        meshId = Renderer.shared.uploadMesh(mesh: mesh)
        materialId = material
    }

    public func start() {
        AudioEngine.shared.start()
        AudioEngine.shared.setListener(position: .zero, rotation: .zero)
        AudioEngine.shared.setVolume(0.05)
        let clip = try! AudioEngine.shared.createClip(from: "H:/Projects/SwiftTest/Resources/Audio/machinedeath.wav")
        let source = AudioEngine.shared.createSource()
        source.setGain(0.1)
        source.setPitch(1)
        source.setClip(clip)
        source.isLooping = true
        source.setPosition(.zero)
        source.play()
        //mainThread.start()
    }

    public func update() {
        Window.processWindowEvents()   
        Renderer.shared.execute(
            drawCall: MeshDrawCall(
                viewportId: 0, 
                layer: 0, 
                translucency: 0, 
                materialId: materialId, 
                depth: 0, 
                meshId: meshId, 
                transform: Transform(position: .zero, rotation: .zero, scale: .zero)
        ))
        Renderer.shared.update()
        Renderer.shared.render()
        AudioEngine.shared.update()

        /*
        mainThread.runOn {
            log(level: .debug, message: "Main Thread - Updating")
            Renderer.shared.update()
            log(level: .debug, message: "Main Thread - Updated")
        }
        */
    }
}

public func runOnMain(_ block: @escaping () -> Void) {
    //GameKit.shared.mainThread.runOn(block)
}

public func system<A>(block: @escaping (UnsafeMutablePointer<A>) -> Void) {
    //GameKit.shared.ecs.registerSystem()
}