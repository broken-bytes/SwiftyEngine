import Core
import MathF
import Models
import OpenAL

public class AudioSource {
    
    private var _isLooping = false
    public var isLooping: Bool {
        get {
            _isLooping
        } set {
            alSourcei(buffer.pointee, AL_LOOPING, newValue ? AL_TRUE : AL_FALSE)
        }
    }

    var clip: AudioClip?
    var buffer: UnsafeMutablePointer<ALuint>!

    public init(with buffer: UnsafeMutablePointer<ALuint>) {
        self.buffer = buffer
    }

    deinit { 
        
    }

    public func setClip(_ clip: AudioClip) {
        self.clip = clip
        alSourcei(self.buffer.pointee, AL_BUFFER, clip.buffer.pointee)

    }

    public func play() {
        alSourcePlay(buffer.pointee)
    }

    public func tick() {
        var state: ALint = 0
        alGetSourcei(buffer.pointee, AL_SOURCE_STATE, &state)
    }

    public func setPitch(_ value: Float) {
        alSourcef(buffer.pointee, AL_PITCH, value)
    }

    public func setGain(_ value: Float) {
        alSourcef(buffer.pointee, AL_GAIN, value)
    }

    public func setPosition(_ value: Vector3) {
        alSourcefv(buffer.pointee, AL_POSITION, [value.x, value.y, value.z])
    }
}