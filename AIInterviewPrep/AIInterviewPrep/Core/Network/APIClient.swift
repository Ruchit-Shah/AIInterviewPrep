//
//  APIClient.swift
//  AIInterviewPrep
//
//  Created by Ruchit on 16/04/26.
//

import Foundation

final class APIClient {
    
    func post(url: URL, body: Data, headers: [String: String]) async throws -> Data {
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        headers.forEach { request.addValue($0.value, forHTTPHeaderField: $0.key) }
        request.httpBody = body
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              200...299 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }
        
        return data
    }
}
