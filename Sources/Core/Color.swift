public struct Color {
    
    public let r: Float
    public let g: Float
    public let b: Float
    public let a: Float

    public static let red = Color(r: 1, g: 0, b: 0, a: 1)
    public static let green = Color(r: 0, g: 1, b: 0, a: 1)
    public static let blue = Color(r: 0, g: 0, b: 1, a: 1)
    public static let white = Color(r: 1, g: 1, b: 1, a: 1)
    public static let black = Color(r: 0, g: 0, b: 0, a: 1)
    public static let clear = Color(r: 0, g: 0, b: 0, a: 0)
}