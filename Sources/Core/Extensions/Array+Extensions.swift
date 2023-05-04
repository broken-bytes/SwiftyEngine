import Foundation

public extension Array where Element == UInt32 {

    var nextFreeValue: Element {
        for x in 0..<UInt32.max {
            if !self.contains(x) {
                return x
            }
        }

        fatalError("Out of bounds")
    }
}