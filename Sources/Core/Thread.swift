import Foundation

public class Thread: Foundation.Thread {
    
    public enum ThreadTarget {
        case main
        case worker
    }

    public var isStopped: Bool = false

    let tHandle: Foundation.Thread
    var blocks: [() -> Void] = []

    override init() {
        self.blocks = []
        self.tHandle = Foundation.Thread()
    }

    public static func make() -> Thread {
        Core.Thread()
    }

    public func runOn(_ block: @escaping () -> Void) {
        blocks.append(block)
    }

    public override func main() {
        while !isStopped {
            for block in blocks { 
                block()
            }   

            blocks = []
        }
    }
}