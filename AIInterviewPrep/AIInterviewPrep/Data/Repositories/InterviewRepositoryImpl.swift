//
//  InterviewRepositoryImpl.swift
//  AIInterviewPrep
//
//  Created by Ruchit on 16/04/26.
//


final class InterviewRepositoryImpl: InterviewRepository {
   
   private let service: OpenAIService
   
   init(service: OpenAIService) {
       self.service = service
   }
   
   func generateQuestion(topic: String, experience: Int) async throws -> String {
       
       let prompt = """
       Act as a senior iOS interviewer.
       Generate a challenging question for \(experience)+ years experience on topic: \(topic).
       Also include 1 follow-up question.
       """
       
       return try await service.send(prompt: prompt)
   }
   
   func evaluateAnswer(question: String, answer: String) async throws -> String {
       
       let prompt = """
       Question: \(question)
       Candidate Answer: \(answer)
       
       Evaluate like a senior interviewer:
       - Score (0-10)
       - Correct Answer
       - Improvements
       """
       
       return try await service.send(prompt: prompt)
   }
}
