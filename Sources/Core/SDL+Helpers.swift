import SDL

public func sdlHandleSafe(_ result: SDL_bool, file: String = #file, function: String = #function, line: Int = #line) -> Void {
    if(result != SDL_TRUE) {
        let err = SDL_GetError()
        fatalError("Failed to execute SDL function\nError: \(String(cString: err!))\n\(file):\(function):\(line)")
    }
}

public func sdlHandleSafe(_ result: Int32, file: String = #file, function: String = #function, line: Int = #line) -> Void {
    if(result != 0) {
        let err = SDL_GetError()
        fatalError("Failed to execute SDL function\nError: \(String(cString: err!))\n\(file):\(function):\(line)")
    }
}


public func sdlHandleSafe<T>(_ block: @escaping () -> T?, file: String = #file, function: String = #function, line: Int = #line) -> T {
    guard let result = block() else {
        let err = SDL_GetError()
        fatalError("Failed to execute SDL function\nError: \(String(cString: err!))\n\(file):\(function):\(line)")
    }

    return result
}