import Core
import Foundation
import OpenAL
import SDL

public class AudioEngine {
    
    public static let shared = AudioEngine()

    var device: OpaquePointer
    var context: OpaquePointer

    private var sources: [AudioSource] = []

    private init() {
        device = alcOpenDevice(nil)
        alIsExtensionPresent("EAX2.0")

        context = alcCreateContext(device, nil)
        alcMakeContextCurrent(context)
    }

    public func start() {

    }

    public func update() {
        
    }

    public func play(clip: AudioClip, on source: AudioSource) {
        source.setClip(clip)
        source.play()
    }

    public func createClip(from path: String) throws -> AudioClip {
        var spec: UnsafeMutablePointer<SDL_AudioSpec> = .allocate(capacity: 1)
        var bytes: UnsafeMutablePointer<UnsafeMutablePointer<Uint8>?> = .allocate(capacity: 1)
        var len: Uint32 = 0

        try! path.withCString { str in 
            if SDL_LoadWAV_RW(
                SDL_RWFromFile(str, "rb"), 
                0, 
                spec, 
                bytes, 
                &len
            ) == nil {
                throw AudioError.clipNotFound(error: String(cString: SDL_GetError()))
            }
        }

        var buffer: UnsafeMutablePointer<Int32> = .allocate(capacity: 1)
        alGenBuffers(1, buffer)

        alBufferData(ALuint(buffer.pointee), sdlFormatToOpenALFormat(spec.pointee.format), bytes, Int32(len), spec.pointee.freq)

        return AudioClip(with: buffer)
    }

    public func createSource() -> AudioSource {
        let source: UnsafeMutablePointer<ALuint> = .allocate(capacity: 1)
        alGenSources(1, source)

        let audioSource = AudioSource(with: source)
        sources.append(audioSource)

        return audioSource
    }

    public func setListener(position: Vector3, rotation: Vector4) {
        alListenerfv(AL_POSITION, [position.x, position.y, position.z])
        alListenerfv(AL_ORIENTATION, [rotation.w, rotation.x, rotation.y, rotation.z])
    }

    public func setVolume(_ value: Float) {
        alListenerf(AL_GAIN, value)
    }
}


fileprivate extension AudioEngine {

    func sdlFormatToOpenALFormat(_ format: SDL_AudioFormat) -> ALenum {
        print(format)
        switch format {
        case UInt16(AUDIO_S16LSB):
            return AL_FORMAT_STEREO16
        case UInt16(AUDIO_F32):
            return 0

        default:
            fatalError()
        }
    }
}