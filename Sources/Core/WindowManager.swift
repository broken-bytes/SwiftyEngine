import SDL

public class WindowManager {
    
    public static let shared = WindowManager()

    private init() {
        SDL_Init(SDL_INIT_VIDEO | SDL_INIT_GAMECONTROLLER)
    }

    public func makeWindow(width: Int32, height: Int32, named: String) -> Window {
        Window(width: width, height: height, named: named)
    }
}