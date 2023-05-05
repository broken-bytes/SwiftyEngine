import Foundation
import OpenAL

public class AudioClip {

    var buffer: UnsafeMutablePointer<Int32>

    init(with buffer: UnsafeMutablePointer<Int32>) {
        self.buffer = buffer
    }

    deinit {

    }
}