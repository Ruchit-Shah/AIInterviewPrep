//
//  AppContainer.swift
//  AIInterviewPrep
//
//  Created by Ruchit on 16/04/26.
//
import Foundation

final class AppContainer {
    
    static let shared = AppContainer()
    
    private init() {}
    
    // MARK: - Services
    lazy var openAIService: OpenAIService = {
        OpenAIService(apiKey: "YOUR_API_KEY")
    }()
    
    // MARK: - Repository
    lazy var interviewRepository: InterviewRepository = {
        InterviewRepositoryImpl(service: openAIService)
    }()
    
    // MARK: - UseCases
    lazy var generateQuestionUseCase = GenerateQuestionUseCase(repository: interviewRepository)
    
    lazy var evaluateAnswerUseCase = EvaluateAnswerUseCase(repository: interviewRepository)
}
