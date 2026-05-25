//
//  InterviewViewModel.swift
//  AIInterviewPrep
//
//  Created by Ruchit on 16/04/26.
//

//import SwiftUI
//import Combine
//
//@MainActor
//final class InterviewViewModel: ObservableObject {
//    
//    @Published var question = ""
//    @Published var answer = ""
//    @Published var feedback = ""
//    @Published var isLoading = false
//    
//    private let generateUseCase = AppContainer.shared.generateQuestionUseCase
//    private let evaluateUseCase = AppContainer.shared.evaluateAnswerUseCase
//    
//    func generateQuestion() {
//        isLoading = true
//        
//        Task {
//            defer { isLoading = false }
//            question = try await generateUseCase.execute(topic: "SwiftUI", experience: 5)
//        }
//    }
//    
//    func submitAnswer() {
//        isLoading = true
//        
//        Task {
//            defer { isLoading = false }
//            feedback = try await evaluateUseCase.execute(question: question, answer: answer)
//        }
//    }
//}

import Foundation
import Combine

@MainActor
final class InterviewViewModel: ObservableObject {
    
    @Published var question = ""
    @Published var answer = ""
    @Published var feedback = ""
    @Published var isLoading = false
    
    let speechRecognizer = SpeechRecognizer()
    
    private let generateUseCase = AppContainer.shared.generateQuestionUseCase
    private let evaluateUseCase = AppContainer.shared.evaluateAnswerUseCase
    
    init() {
        speechRecognizer.requestPermission()
        
        // Bind speech → answer
        speechRecognizer.$transcribedText
            .assign(to: &$answer)
    }
    
    func toggleRecording() {
        do {
            if speechRecognizer.isRecording {
                speechRecognizer.stopRecording()
            } else {
                try speechRecognizer.startRecording()
            }
        } catch {
            print("Recording error:", error)
        }
    }

    func generateQuestion() {
        isLoading = true
        feedback = ""

        Task {
            defer { isLoading = false }

            do {
                question = try await generateUseCase.execute(topic: "SwiftUI", experience: 5)
            } catch {
                question = ""
                feedback = error.localizedDescription
            }
        }
    }

    func submitAnswer() {
        isLoading = true

        Task {
            defer { isLoading = false }

            do {
                feedback = try await evaluateUseCase.execute(question: question, answer: answer)
            } catch {
                feedback = error.localizedDescription
            }
        }
    }
}
