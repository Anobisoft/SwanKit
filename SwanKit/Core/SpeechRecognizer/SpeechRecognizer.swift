//
//  SpeechRecognizer.swift
//  SwanKit
//
//  Created by Stanislav Pletnev on 2026-07-16.
//  Copyright © 2026 Anobisoft. Licensed under the MIT License.
//

#if !os(tvOS)

import AVFoundation
import Speech

/// A MainActor-isolated manager responsible for capturing live microphone audio and streaming it into Apple's Speech Recognition engine.
///
/// `SpeechRecognizer` orchestrates `AVAudioEngine` nodes and `SFSpeechRecognizer` tasks, automatically ensuring
/// all required application sandbox privacy permissions are satisfied before initializing hardware audio recording taps.
@MainActor
public class SpeechRecognizer {

    /// A closure block signature invoked to deliver incremental transcription string results or error signals (`nil`).
    public typealias ResultHandler = @MainActor (String?) -> Void

    private var resultHandler: ResultHandler
    private let audioEngine = AVAudioEngine()
    private let speechRecognizer: SFSpeechRecognizer
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private var granted = false

    /// Initializes a speech recognizer instance bound to a specific result delivery handler closure.
    /// - Parameter resultHandler: The MainActor-isolated closure block to receive transcription texts updates.
    public init(_ resultHandler: @escaping ResultHandler) {
        self.resultHandler = resultHandler
        // Safely fallback initialize or throw default container if initialization fails
        self.speechRecognizer = SFSpeechRecognizer() ?? SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
    }

    /// Asynchronously requests all necessary privacy permissions and initiates active device microphone capture streaming.
    ///
    /// If user authorization boundaries for Speech Recognition or Microphone hardware are denied,
    /// the provider automatically redirects the active viewport context into the system settings board.
    public func startRecording() {
        Task {
            if !granted {
                guard await Access.SpeechRecognizer.requestAccess() == .authorized else {
                    Access.SpeechRecognizer.openSettings()
                    return
                }

                guard await Access.Capture.Audio.requestAccess() else {
                    Access.Capture.Audio.openSettings()
                    return
                }

                self.granted = true
            }
            // Mutate isolated state safely on the MainActor domain context
            self.startGrantedRecording()
        }
    }

    /// Explicitly halts microphone audio recording taps and finalizes the current transcription buffer cycle.
    public func stopRecording() {
        guard granted else {
            resultHandler("")
            return
        }
        audioEngine.inputNode.removeTap(onBus: 0)
        audioEngine.stop()
        request?.endAudio()
    }

    // MARK: - Private Hardware Execution Streams

    private func startGrantedRecording() {
        let node = audioEngine.inputNode
        node.removeTap(onBus: 0)

        // Install real-time thread audio bus tap buffer pipeline capture
        node.installTap(onBus: 0, bufferSize: 1024, format: nil) { [weak self] (buffer, _) in
            Task { @MainActor in
                self?.request?.append(buffer)
            }
        }

        audioEngine.prepare()
        try? audioEngine.start()

        let request = SFSpeechAudioBufferRecognitionRequest()
        self.request = request

        // Instantiate the managed tracking self-retaining interceptor handler delegate
        let handler = SpeechRecognitionHandler(resultHandler)
        recognitionTask = speechRecognizer.recognitionTask(with: request, delegate: handler)
    }
}

// MARK: - Private Interceptor Task Delegate Wrapper

/// A specialized delegate interceptor designed to hold a volatile lifetime reference cycle during active transcription operations.
private class SpeechRecognitionHandler: NSObject, SFSpeechRecognitionTaskDelegate, @unchecked Sendable {

    typealias ResultHandler = SpeechRecognizer.ResultHandler

    private let completion: ResultHandler
    private var selfRetain: SpeechRecognitionHandler?

    init(_ completion: @escaping ResultHandler) {
        self.completion = completion
        super.init()
        selfRetain = self
    }

    func speechRecognitionTask(_ task: SFSpeechRecognitionTask, didFinishRecognition recognitionResult: SFSpeechRecognitionResult) {
        let transcription = recognitionResult.bestTranscription.formattedString
        Task { @MainActor in
            completion(transcription)
        }
    }

    func speechRecognitionTask(_ task: SFSpeechRecognitionTask, didFinishSuccessfully successfully: Bool) {
        selfRetain = nil
        if successfully { return }
        Task { @MainActor in
            completion(nil)
        }
    }
}

#endif
