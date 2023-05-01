import GameKit

public class Assembly {
    public init() {
        GameKit.shared.start()
        while true {
            GameKit.shared.update()
        }
    }
}