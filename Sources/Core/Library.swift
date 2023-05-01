#if os(Windows)
import WinSDK
typealias LibHandle = HMODULE
#endif

public class Library {

    public enum LibraryError: Error {
        case libraryNotFound
        case functionNotFound
    }

    private let handle: LibHandle

    fileprivate init(handle: LibHandle!) throws {
        guard let handle else {
            throw LibraryError.libraryNotFound
        }

        self.handle = handle
    }

    public func loadFunction<T>(with name: String) throws -> T {
        guard var proc = GetProcAddress(handle, name) else {
            throw LibraryError.functionNotFound
        }
        
        return withUnsafeMutablePointer(to: &proc) {
            UnsafeMutableRawPointer($0).load(as: T.self)
        }
    }
}

public func loadLibrary(at path: String) throws -> Library {
#if os(Windows)
    try! Library(handle: LoadLibraryA(path))
#endif
}