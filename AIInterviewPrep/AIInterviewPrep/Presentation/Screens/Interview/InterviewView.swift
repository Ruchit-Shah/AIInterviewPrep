//
//  InterviewView.swift
//  AIInterviewPrep
//
//  Created by Ruchit on 16/04/26.
//

import SwiftUI

struct InterviewView: View {
    
    @StateObject private var vm = InterviewViewModel()
    
    var body: some View {
        VStack(spacing: 16) {
            
            // MARK: - Title
            Text("AI Interview Prep")
                .font(.title.bold())
            
            // MARK: - Question Section
            VStack(alignment: .leading, spacing: 8) {
                Text("Question")
                    .font(.headline)
                
                ScrollView {
                    Text(vm.question.isEmpty ? "Tap Generate to start interview" : vm.question)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                }
                .frame(height: 120)
            }
            
            // MARK: - Answer Input + Mic
            VStack(alignment: .leading, spacing: 8) {
                Text("Your Answer")
                    .font(.headline)
                
                HStack {
                    TextField("Type or speak your answer...", text: $vm.answer)
                        .textFieldStyle(.roundedBorder)
                    
                    // 🎤 Mic Button
                    Button(action: {
                        vm.toggleRecording()
                    }) {
                        Image(systemName: vm.speechRecognizer.isRecording ? "mic.fill" : "mic")
                            .font(.title2)
                            .foregroundColor(vm.speechRecognizer.isRecording ? .red : .blue)
                    }
                }
                
                // 🎤 Recording Indicator
                if vm.speechRecognizer.isRecording {
                    Text("🎤 Listening...")
                        .font(.caption)
                        .foregroundColor(.red)
                }
            }
            
            // MARK: - Actions
            HStack(spacing: 12) {
                
                Button(action: {
                    vm.generateQuestion()
                }) {
                    Text("Generate")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(vm.isLoading)
                
                Button(action: {
                    vm.submitAnswer()
                }) {
                    Text("Submit")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(vm.answer.isEmpty ? Color.gray : Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(vm.answer.isEmpty || vm.isLoading)
            }
            
            // MARK: - Loader
            if vm.isLoading {
                ProgressView("Processing...")
                    .padding()
            }
            
            // MARK: - Feedback
            VStack(alignment: .leading, spacing: 8) {
                Text("Feedback")
                    .font(.headline)
                
                ScrollView {
                    Text(vm.feedback.isEmpty ? "Your feedback will appear here" : vm.feedback)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .foregroundColor(.gray)
                }
                .frame(height: 150)
            }
            
            Spacer()
        }
        .padding()
    }
}
