import GameKit
import IO
import MathF
import Rendering

GameKit.shared.start()

let meshes = try! AssetLoader.shared.loadModel(at: "H:/Projects/SwiftTest/Resources/Models/cans/russian_food_cans_01_1k.gltf")
var meshIds: [UInt32] = []
for model in meshes {
    meshIds.append(Renderer.shared.uploadMesh(mesh: model))
}

var view = lookAtLH(eye: .zero, target: .zero + Vector3(x: 0, y: 0, z: 0.1))
var projection = perspectiveFovLH(fov: 60, aspect: 1.6, nearDist: 0.01, farDist: 1000)
debugPrint(view)
debugPrint(projection)

while true {
    for mesh in meshIds {
        Renderer.shared.draw(entityId: 0, meshId: mesh, materialId: 0, transform: .init(position: .zero, rotation: .identity, scale: .one))
    }
    GameKit.shared.update()    
}