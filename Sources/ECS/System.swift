import Flecs

public struct System {
    let sysHandle: UInt64

    init(world: OpaquePointer, types: [Any.Type], block: @convention(c) () -> Void) {
        var desc = ecs_system_desc_t()
        desc.multi_threaded = true
        ecs_system_init(world, &desc)
        sysHandle = 0
    }
}



func move(it: UnsafePointer<ecs_iter_t>) {
    // Get fields from system query
    var pos: UInt64 = ecs_field_id(it, 0)

    // Iterate matched entities
    for x in 0..<it.pointee.count {

    }
}

// System declaration
