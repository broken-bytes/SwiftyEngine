import Foundation

public enum LogLevel {
    case info
    case debug
    case warn
    case error
}

#if os(Windows)
import WinSDK

public func initLogger() {
   
}

public func log(level: LogLevel, message: String) {
    switch level {
        case .info:
            print("INFO: \(Date().debugDescription) \(message)\n")
        case .debug:
            print("DEBUG: \(Date().debugDescription) \(message)\n")
        case .warn:
            print("WARN: \(Date().debugDescription) \(message)\n")
        case .error:
            print("ERROR: \(Date().debugDescription) \(message)\n")
    }
}
#endif

#if os(macOS)
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
#endif

