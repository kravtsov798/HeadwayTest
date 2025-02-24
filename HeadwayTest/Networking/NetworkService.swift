//
//  NetworkService.swift
//  HeadwayTestTask
//
//  Created by Andrii Kravtsov on 17.02.2025.
//

import Foundation
import Dependencies

enum NetworkingDependencyKey: DependencyKey {
    static let liveValue: Networking = NetworkService()
}

extension DependencyValues {
    var networkService: Networking {
        get { self[NetworkingDependencyKey.self] }
        set { self[NetworkingDependencyKey.self] = newValue }
    }
}

protocol Networking {
    func request<T: Decodable>(url: URL?) async throws -> T
}

final class NetworkService: Networking {
    private let session: URLSession
     
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    func request<T: Decodable>(url: URL?) async throws -> T {
        guard let url else { throw NetworkError.invalidURL }
        
        let urlRequest = URLRequest(url: url)
        let (data, response) = try await session.data(for: urlRequest)
        try checkResponseStatusCode(response)
        return try decode(from: data)
    }
    
    private func checkResponseStatusCode(_ response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        let statusCode = httpResponse.statusCode
        
        guard (200...299).contains(statusCode) else {
            throw switch statusCode {
            case 400...499: NetworkError.clientError(code: statusCode)
            case 500...599: NetworkError.serverError(code: statusCode)
            default: NetworkError.unknownError(code: statusCode)
            }
        }
    }
    
    private func decode<T: Decodable>(from data: Data) throws -> T {
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingFailed(description: error.localizedDescription)
        }
    }
}
