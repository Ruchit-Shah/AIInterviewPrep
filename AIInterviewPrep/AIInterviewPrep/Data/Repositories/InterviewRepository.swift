//
//  InterviewRepository.swift
//  AIInterviewPrep
//
//  Created by Ruchit on 16/04/26.
//

protocol InterviewRepository {
    func generateQuestion(topic: String, experience: Int) async throws -> String
    func evaluateAnswer(question: String, answer: String) async throws -> String
}
