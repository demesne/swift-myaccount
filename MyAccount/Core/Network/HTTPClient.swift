//
//  HTTPClient.swift
//  MyAccount
//
//  Created by Kumar Abhinav on 2025-07-07.
//

import Foundation

protocol HTTPClient {
    func performRequest<T: Codable>(
        endpoint: APIEndpoints,
        body: Data?,
        headers: [String: String]?,
        responseType: T.Type
    ) async throws -> T
    
    func performRequest(
        endpoint: APIEndpoints,
        body: Data?,
        headers: [String: String]?
    ) async throws -> (Data, HTTPURLResponse)
}

class URLSessionHTTPClient: HTTPClient {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func performRequest<T: Codable>(
        endpoint: APIEndpoints,
        body: Data? = nil,
        headers: [String: String]? = nil,
        responseType: T.Type
    ) async throws -> T {
        let (data, response) = try await performRequest(endpoint: endpoint, body: body, headers: headers)
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(responseType, from: data)
        } catch {
            throw AuthError.invalidResponse
        }
    }
    
    func performRequest(
        endpoint: APIEndpoints,
        body: Data? = nil,
        headers: [String: String]? = nil
    ) async throws -> (Data, HTTPURLResponse) {
        var request = URLRequest(url: endpoint.url)
        request.httpMethod = endpoint.httpMethod
        request.httpBody = body
        
        // Add endpoint-specific headers
        for (key, value) in endpoint.headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        // Add additional headers
        if let headers = headers {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw AuthError.invalidResponse
            }
            
            switch httpResponse.statusCode {
            case 200...299:
                return (data, httpResponse)
            case 401:
                throw AuthError.unauthorized
            case 400...499:
                throw AuthError.invalidCredentials
            case 500...599:
                throw AuthError.serverError(httpResponse.statusCode)
            default:
                throw AuthError.unknown
            }
        } catch {
            if error is AuthError {
                throw error
            }
            throw AuthError.networkError(error)
        }
    }
}
