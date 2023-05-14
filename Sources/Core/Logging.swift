import Foundation
import WinSDK

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
    if level == .error {
        MessageBoxA(nil, message, "Error", 0)
    }
    if level.shouldLog {
        print("\(level.rawValue): \(Date().debugDescription) \(message)")
    }
}

public func log(level: LogLevel, object: Any) {
    if level == .error {
        MessageBoxA(nil, "\(level.rawValue): \(Date().debugDescription) \(type(of: object))", "Error", 0)
    }
    if level.shouldLog {
        print("\(level.rawValue): \(Date().debugDescription) \(type(of: object))")
        for prop in Mirror(reflecting: object).children {
            print("- Name: \(prop.label!): \(prop.value)")
        }
    }
}

