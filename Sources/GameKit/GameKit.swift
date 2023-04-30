import Core
import ECS
import Rendering

public class GameKit {

    public static let shared = GameKit()

    private var mainThread: Thread
    private var mainWindow: Window!

    private var inputThread: Thread

    private init() {
        mainThread = Thread.make {}
        inputThread = Thread.make {}
        
        mainThread.runOn {
            while self.mainWindow == nil {

            }
            Renderer.shared.bind(to: self.mainWindow)
            while true {
                self.update()
            }
        }

        inputThread.runOn {
            self.mainWindow = WindowManager.shared.makeWindow(width: 1200, height: 800, named: "MainWindow")

            while true {
                Window.processWindowEvents()
            }
        }

        inputThread.start()
        mainThread.start()

        while true { 
            // Hold the application main thread.
        }
    }

    public func update() {
        Renderer.shared.update()
    }
}

public func runOnMain(_ block: @escaping () -> Void) {
    //GameKit.shared.mainThread.runOn(block)
}

public func system<A>(block: @escaping (UnsafeMutablePointer<A>) -> Void) {
    //GameKit.shared.ecs.registerSystem()
}