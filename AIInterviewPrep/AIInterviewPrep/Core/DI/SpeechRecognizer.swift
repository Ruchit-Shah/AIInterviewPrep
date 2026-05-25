//
//  SpeechRecognizer.swift
//  AIInterviewPrep
//
//  Created by Ruchit on 17/04/26.
//

import Foundation
import Speech
import AVFoundation
import Combine

final class SpeechRecognizer: ObservableObject {
    
    private let recognizer = SFSpeechRecognizer()
    private let audioEngine = AVAudioEngine()
    
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var task: SFSpeechRecognitionTask?
    
    @Published var transcribedText: String = ""
    @Published var isRecording = false
    
    // MARK: - Permission
    func requestPermission() {
        SFSpeechRecognizer.requestAuthorization { status in
            DispatchQueue.main.async {
                print("Speech auth status:", status.rawValue)
            }
        }
    }
    
    // MARK: - Start Recording
    func startRecording() throws {
        
        stopRecording()
        
        let node = audioEngine.inputNode
        request = SFSpeechAudioBufferRecognitionRequest()
        
        guard let request = request else { return }
        
        request.shouldReportPartialResults = true
        
        task = recognizer?.recognitionTask(with: request) { [weak self] result, error in
            guard let self = self else { return }
            
            if let result = result {
                DispatchQueue.main.async {
                    self.transcribedText = result.bestTranscription.formattedString
                }
            }
            
            if error != nil {
                self.stopRecording()
            }
        }
        
        let format = node.outputFormat(forBus: 0)
        
        node.installTap(onBus: 0, bufferSize: 1024, format: format) { buffer, _ in
            request.append(buffer)
        }
        
        audioEngine.prepare()
        try audioEngine.start()
        
        DispatchQueue.main.async {
            self.isRecording = true
        }
    }
    
    // MARK: - Stop Recording
    func stopRecording() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        
        request?.endAudio()
        task?.cancel()
        
        DispatchQueue.main.async {
            self.isRecording = false
        }
    }
}
