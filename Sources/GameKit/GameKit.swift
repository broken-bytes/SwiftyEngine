import Core
import ECS
import Rendering
import WinSDK

public class GameKit {

    public static let shared = GameKit()

    private var mainWindow: Window!

    private init() {
        initLogger()
        log(level: .debug, message: "Main Thread - Creating")
        log(level: .debug, message: "Main Thread - Created")
        log(level: .debug, message: "Main Window - Creating")
        mainWindow = WindowManager.shared.makeWindow(width: 1200, height: 800, named: "MainWindow")
        log(level: .debug, message: "Main Window - Created")
        log(level: .debug, message: "Renderer - Binding")
        Renderer.shared.bind(to: self.mainWindow)
        log(level: .debug, message: "Renderer - Bound")
        log(level: .debug, message: "Main Thread - Starting")
        log(level: .debug, message: "Main Thread - Started")

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
    }

    public func start() {
        //mainThread.start()
    }

    public func update() {
        Window.processWindowEvents()   
        Renderer.shared.update()

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