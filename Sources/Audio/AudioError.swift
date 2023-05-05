public enum AudioError: Error {
    case clipNotFound(error: String)
    case clipNotWav
}