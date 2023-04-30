import Core

public struct Mesh {

    public internal(set) var vertices: [Vertex] { 
        set {
            self.temporaryVertices = newValue
        }
        get {
            self.loadVertexData() 
        }
    }

    public internal(set) var normals: [Vector3] { 
        set {
            self.temporaryNormals = newValue
        }
        get {
            self.loadNormalsData() 
        }
    }

    public internal(set) var tangents: [Vector3] { 
        set {
            self.temporaryTangents = newValue
        }
        get {
            self.loadTangentsData() 
        }
    }

    public internal(set) var uvs: [Vector2] { 
        set {
            self.temporaryUVs = newValue
        }
        get {
            self.loadUVsData() 
        }
    }
    
    public let meshId: UInt64

    internal var temporaryVertices: [Vertex] = []
    internal var temporaryNormals: [Vector3] = []
    internal var temporaryTangents: [Vector3] = []
    internal var temporaryUVs: [Vector2] = []

    public init() {
        meshId = 0
    }

    /// Takes the changed vertex, normal, tangent, and uv data since the last bake and applies it to the mesh
    public mutating func bake() {
        writeVertexData()
        writeNormalsData()
        writeTangentsData()
        writeUVsData()

        temporaryVertices = []
        temporaryNormals = []
        temporaryTangents = []
        temporaryUVs = []
    }

    internal func writeVertexData() -> Void {

    }

    internal func loadVertexData() -> [Vertex] {
        []
    }

    internal func writeNormalsData() -> Void {
        
    }

    internal func loadNormalsData() -> [Vector3] {
        []
    }

    internal func writeTangentsData() -> Void {
        
    }

    internal func loadTangentsData() -> [Vector3] {
        []
    }

    internal func writeUVsData() -> Void {
        
    }

    internal func loadUVsData() -> [Vector2] {
        []
    }
}