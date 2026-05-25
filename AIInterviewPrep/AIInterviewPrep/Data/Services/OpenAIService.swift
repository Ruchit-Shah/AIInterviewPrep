//
//  OpenAIService.swift
//  AIInterviewPrep
//
//  Created by Ruchit on 16/04/26.
//
import Foundation

private struct OpenAIResponse: Decodable {
    let choices: [Choice]

    struct Choice: Decodable {
        let message: Message
    }

    struct Message: Decodable {
        let content: String
    }
}

final class OpenAIService {
    
    private let apiKey: String
    private let client = APIClient()
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    func send(prompt: String) async throws -> String {
        
        let url = URL(string: "https://api.openai.com/v1/chat/completions")!
        
        let body: [String: Any] = [
            "model": "gpt-4o-mini",
            "messages": [
                ["role": "system", "content": "You are an expert iOS interviewer."],
                ["role": "user", "content": prompt]
            ]
        ]
        
        let data = try JSONSerialization.data(withJSONObject: body)
        
        let responseData = try await client.post(
            url: url,
            body: data,
            headers: [
                "Authorization": "Bearer \(apiKey)",
                "Content-Type": "application/json"
            ]
        )
        
        let decoded = try JSONDecoder().decode(OpenAIResponse.self, from: responseData)
        return decoded.choices.first?.message.content ?? ""
    }
}
