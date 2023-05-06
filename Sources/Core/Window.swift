import SDL

public struct Window {
    public var windowPtr: OpaquePointer!
    var isClosed: Bool = false

    public init(width: Int32, height: Int32, named: String) {
        SDL_Init(SDL_INIT_AUDIO | SDL_INIT_GAMECONTROLLER)
        windowPtr = sdlHandleSafe { 
            SDL_CreateWindow(named, 0x2FFF0000, 0x2FFF0000, width, height, UInt32(SDL_WINDOW_VULKAN.rawValue)) 
        }
    }

    public static func processWindowEvents() {
        var event = UnsafeMutablePointer<SDL_Event>.allocate(capacity: 1)
        while SDL_PollEvent(event) != 0 {
            processEvent(event)
        }
    }

    public mutating func close() {
        isClosed = true
    }

    private static func processEvent(_ event: UnsafeMutablePointer<SDL_Event>) {
        switch event.pointee.type {
        case UInt32(SDL_KEYDOWN.rawValue):
            processKeyEvent(event, isKeyDown: true)
        case UInt32(SDL_KEYUP.rawValue):
            processKeyEvent(event, isKeyDown: false)
        case UInt32(SDL_WINDOWEVENT.rawValue):
            processWindowEvent(event)
        default:
            break
        }
    }

    private static func processKeyEvent(_ event: UnsafeMutablePointer<SDL_Event>, isKeyDown: Bool) {

    }

    private static func processWindowEvent(_ event: UnsafeMutablePointer<SDL_Event>) {
        switch (event.pointee.window.event) {

            case UInt8(SDL_WINDOWEVENT_CLOSE.rawValue):   // exit game
                exit(0)
                break;
            case UInt8(SDL_WINDOWEVENT_RESIZED.rawValue):
                break
            default:
                break;
        }
    }
}
