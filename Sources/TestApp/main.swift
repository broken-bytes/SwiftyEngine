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

while true {
    for mesh in meshIds {
        Renderer.shared.draw(
            entityId: 0, 
            meshId: mesh, 
            materialId: 0, 
            transform: .init(
                position: Vector3(x: 0, y: 0, z: 50), 
                rotation: Quaternion(x: 0, y: 0.609, z: 0, w: 0.793), 
                scale: .one
            )
        )
    }
    GameKit.shared.update()    
}