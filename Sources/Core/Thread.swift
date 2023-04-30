import Foundation

public class Thread: Foundation.Thread {
    
    public enum ThreadTarget {
        case main
        case worker
    }

    let tHandle: Foundation.Thread
    var blocks: [() -> Void] = []

    init(with block: @escaping () -> Void) {
        self.blocks = [block]
        self.tHandle = Foundation.Thread()
    }

    public static func make(_ block: @escaping () -> Void) -> Thread {
        Thread(with: block)
    }

    public func runOn(_ block: @escaping () -> Void) {
        blocks.append(block)
    }

    public override func main() {
        for block in blocks { 
            block()
        }

        blocks = []
    }
}