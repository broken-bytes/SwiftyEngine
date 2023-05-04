import Foundation

public extension Dictionary where Key == UInt32, Value == any Hashable {

    var nextKey: UInt32 {
        for x in 0..<UInt32.max {
            if self[x] != nil {
                return x
            }
        }

        fatalError("Out of bounds")
    }

    mutating func assignToNextFree(_ value: inout Value) -> (Key, Value) {
        let nextFree = nextKey
        self[nextFree] = value

        return (nextFree, value)
    }
}