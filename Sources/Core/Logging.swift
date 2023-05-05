import Foundation

public enum LogLevel: String {
    case info = "Info"
    case debug = "Debug"
    case warn = "Warn"
    case error = "Error"

    var shouldLog: Bool {
        switch self {
        case .info, .debug:
            #if DEBUG
            return true
            #else
            return false
            #endif
        case .warn, .error:
            return true
        }
    }
}

public func initLogger() {

}

public func log(level: LogLevel, message: String) {
    if level.shouldLog {
        print("\(level.rawValue): \(Date().debugDescription) \(message)")
    }
}

