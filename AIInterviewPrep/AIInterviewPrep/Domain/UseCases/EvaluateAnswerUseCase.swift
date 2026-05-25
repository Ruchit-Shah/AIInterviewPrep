//
//  EvaluateAnswerUseCase.swift
//  AIInterviewPrep
//
//  Created by Ruchit on 16/04/26.
//

import Foundation

protocol EvaluateAnswerUseCaseProtocol {
    func execute(question: String, answer: String) async throws -> String
}

final class EvaluateAnswerUseCase: EvaluateAnswerUseCaseProtocol {
    
    private let repository: InterviewRepository
    
    init(repository: InterviewRepository) {
        self.repository = repository
    }
    
    /// Evaluates candidate answer and returns feedback
    func execute(question: String, answer: String) async throws -> String {
        
        // Input validation
        guard !question.trimmingCharacters(in: .whitespaces).isEmpty else {
            throw UseCaseError.invalidInput("Question cannot be empty")
        }
        
        guard !answer.trimmingCharacters(in: .whitespaces).isEmpty else {
            throw UseCaseError.invalidInput("Answer cannot be empty")
        }
        
        do {
            let result = try await repository.evaluateAnswer(
                question: question,
                answer: answer
            )
            
            return result.trimmingCharacters(in: .whitespacesAndNewlines)
            
        } catch {
            throw UseCaseError.executionFailed(error.localizedDescription)
        }
    }
}
