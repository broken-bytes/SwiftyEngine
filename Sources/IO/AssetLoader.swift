import Core
import Foundation
import MathF
import Models
import SwiftyGLTF

public enum AssetError: Error {
    case fileNotFound
    case fileInvalid
}

public class AssetLoader {

    public static let shared = AssetLoader()

    private init() {}

    public func loadModel(at path: String) throws -> [MeshData] {

        var meshData: [MeshData] = []

        let gltf = try GlTFLoader().loadData(at: path)

        guard let accessors = gltf.accessors else {
            return []
        }

        guard let bufferViews = gltf.bufferViews else {
            return []
        }

        guard let buffers = gltf.buffers else {
            return []
        }

        guard let meshes = gltf.meshes else {
            return []
        }

        var bufferData: [String:Data] = [:]

        for mesh in meshes {
            for primitive in mesh.primitives {
                var posAcc: GlTFAccessor! = nil
                var uvAcc: GlTFAccessor! = nil
                for attribute in primitive.attributes {
                    switch attribute {
                        case .position(let position):
                        posAcc = accessors[position]
                        case .texcoord0(let tex):
                        uvAcc = accessors[tex]
                        default:
                        break
                    }
                }

                guard let posViewIndex = posAcc.bufferView else {
                    break
                }

                let posView = bufferViews[posViewIndex]
                let posBuffer = buffers[posView.buffer]
                if !bufferData.contains(where: { $0.key == posBuffer.uri! }) {
                    let actualPath = path.replacing(path.lastPathComponent, with: "")
                    bufferData[posBuffer.uri!] = try Data(contentsOf: URL(fileURLWithPath: actualPath.appending(posBuffer.uri!)))
                }

                let posData = bufferData[posBuffer.uri!]!
                    .advanced(by: posView.byteOffset!)
                    .subdata(in: 0..<posView.byteLength)

                var posVec3Array: [Vector3] = [Vector3](repeating: .init(x: 0, y: 0, z: 0), count: posData.count / MemoryLayout<Vector3>.stride)
                
                posData.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) in
                    let vec3Buffer = UnsafeBufferPointer(start: bytes.bindMemory(to: Vector3.self).baseAddress, count: posVec3Array.count)
                    posVec3Array = Array(vec3Buffer)
                }

                guard let uvViewIndex = uvAcc.bufferView else {
                    break
                }

                let uvView = bufferViews[uvViewIndex]
                let uvBuffer = buffers[uvView.buffer]
                if !bufferData.contains(where: { $0.key == uvBuffer.uri! }) {
                    let actualPath = path.replacing(path.lastPathComponent, with: "")
                    bufferData[uvBuffer.uri!] = try Data(contentsOf: URL(fileURLWithPath: actualPath.appending(uvBuffer.uri!)))
                }

                let uvData = bufferData[uvBuffer.uri!]!
                    .advanced(by: uvView.byteOffset!)
                    .subdata(in: 0..<uvView.byteLength)

                var uvVec2Array: [Vector2] = [Vector2](repeating: .init(x: 0, y: 0), count: uvData.count / MemoryLayout<Vector2>.stride)
                
                uvData.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) in
                    let uvVec2Buffer = UnsafeBufferPointer(start: bytes.bindMemory(to: Vector2.self).baseAddress, count: uvVec2Array.count)
                    uvVec2Array = Array(uvVec2Buffer)
                }

                let primitiveVertices = Array(zip(posVec3Array, uvVec2Array)).map { 
                    Vertex(position: $0.0, uv: $0.1, color: .white)
                }

                guard let indViewIndex = primitive.indices else {
                    break
                }

                let indView = bufferViews[indViewIndex]
                let indBuffer = buffers[indView.buffer]
                if !bufferData.contains(where: { $0.key == indBuffer.uri! }) {
                    let actualPath = path.replacing(path.lastPathComponent, with: "")
                    bufferData[uvBuffer.uri!] = try Data(contentsOf: URL(fileURLWithPath: actualPath.appending(uvBuffer.uri!)))
                }

                let indData = bufferData[indBuffer.uri!]!
                    .advanced(by: indView.byteOffset!)
                    .subdata(in: 0..<indView.byteLength)

                var indUInt16Array: [UInt16] = [UInt16](repeating: 0, count: indData.count / MemoryLayout<UInt16>.stride)
                
                indData.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) in
                    let indBuffer = UnsafeBufferPointer(start: bytes.bindMemory(to: UInt16.self).baseAddress, count: indUInt16Array.count)
                    indUInt16Array = Array(indBuffer)
                }

                meshData.append(MeshData(vertices: primitiveVertices, indices: indUInt16Array))
            }
        }

        return meshData
    }
}