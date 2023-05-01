import Vulkan

struct Viewport {

    var x: UInt32
    var y: UInt32
    var width: UInt32
    var height: UInt32

    init(x: UInt32, y: UInt32, width: UInt32, height: UInt32) {
        self.x = x
        self.y = y
        self.width = width
        self.height = height 
    }
}