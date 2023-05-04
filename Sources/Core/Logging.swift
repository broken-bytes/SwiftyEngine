import Foundation

public enum LogLevel {
    case info
    case debug
    case warn
    case error
}

public func initLogger() {

}

public func log(level: LogLevel, message: String) {
    switch level {
        case .info:
            print("INFO: \(Date().debugDescription) \(message)")
        case .debug:
            print("DEBUG: \(Date().debugDescription) \(message)")
        case .warn:
            print("WARN: \(Date().debugDescription) \(message)")
        case .error:
            print("ERROR: \(Date().debugDescription) \(message)")
    }
}

