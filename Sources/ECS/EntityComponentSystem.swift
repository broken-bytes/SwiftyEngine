import Flecs

class EntityComponentSystem {
    var world: OpaquePointer

    init() {
        self.world = ecs_init()
    }

    public func registerSystem<A>(block: @escaping (UnsafeMutablePointer<A>) -> Void) {

    }

    public func registerSystem<A, B>(block: @escaping (UnsafeMutablePointer<A>, UnsafeMutablePointer<B>) -> Void) {

    }
}