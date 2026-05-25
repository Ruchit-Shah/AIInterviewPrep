//
//  GenerateQuestionUseCase.swift
//  AIInterviewPrep
//
//  Created by Ruchit on 16/04/26.
//

import Foundation

protocol GenerateQuestionUseCaseProtocol {
    func execute(topic: String, experience: Int) async throws -> String
}

final class GenerateQuestionUseCase: GenerateQuestionUseCaseProtocol {
    
    private let repository: InterviewRepository
    
    init(repository: InterviewRepository) {
        self.repository = repository
    }
    
    /// Generates an interview question based on topic & experience
    func execute(topic: String, experience: Int) async throws -> String {
        
        // Input validation (important for production)
        guard !topic.trimmingCharacters(in: .whitespaces).isEmpty else {
            throw UseCaseError.invalidInput("Topic cannot be empty")
        }
        
        guard experience > 0 else {
            throw UseCaseError.invalidInput("Experience must be greater than 0")
        }
        
        do {
            let result = try await repository.generateQuestion(
                topic: topic,
                experience: experience
            )
            
            return result.trimmingCharacters(in: .whitespacesAndNewlines)
            
        } catch {
            throw UseCaseError.executionFailed(error.localizedDescription)
        }
    }
}

enum UseCaseError: LocalizedError {
    case invalidInput(String)
    case executionFailed(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidInput(let message):
            return message
        case .executionFailed(let message):
            return message
        }
    }
}
