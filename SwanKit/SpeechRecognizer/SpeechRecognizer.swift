
import Speech
import AVFoundation

public class SpeechRecognizer {
    public typealias ResultHandler = (String?) -> Void

    private var resultHandler: ResultHandler

    public init(_ resultHandler: @escaping ResultHandler) {
        self.resultHandler = resultHandler
    }

    private let audioEngine = AVAudioEngine()
    private let speechRecognizer: SFSpeechRecognizer = SFSpeechRecognizer()!
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask!

    @MainActor
    public func startRecording() {
        Task {
            guard await Access.SpeechRecognizer.requestAccess() == .authorized else {
                Access.SpeechRecognizer.openSettings()
                return
            }
            guard await Access.Audio.requestAccess() else {
                Access.Audio.openSettings()
                return
            }
            granted = true
            startGrantedRecording()
        }
    }

    private var granted = false

    public func stopRecording() {
        guard granted else {
            resultHandler("")
            return
        }
        audioEngine.inputNode.removeTap(onBus: 0)
        audioEngine.stop()
        request?.endAudio()
    }

    private func startGrantedRecording() {
        let node = audioEngine.inputNode
        node.removeTap(onBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: nil) { [weak self] (buffer, _) in
            self?.request?.append(buffer)
        }
        audioEngine.prepare()
        try? audioEngine.start()
        let request = SFSpeechAudioBufferRecognitionRequest()
        self.request = request
        recognitionTask = speechRecognizer.recognitionTask(with: request, delegate: SpeechRecognitionHandler(resultHandler))
    }
}

private class SpeechRecognitionHandler: NSObject, SFSpeechRecognitionTaskDelegate {

    typealias ResultHandler = SpeechRecognizer.ResultHandler

    var completion: ResultHandler
    var selfretain: SpeechRecognitionHandler?

    init(_ completion: @escaping ResultHandler) {
        self.completion = completion
        super.init()
        selfretain = self
    }

    func speechRecognitionTask(_ task: SFSpeechRecognitionTask, didFinishRecognition recognitionResult: SFSpeechRecognitionResult) {
        completion(recognitionResult.bestTranscription.formattedString)
    }

    func speechRecognitionTask(_ task: SFSpeechRecognitionTask, didFinishSuccessfully successfully: Bool) {
        if !successfully {
            completion(nil)
        }
        selfretain = nil
    }
}
