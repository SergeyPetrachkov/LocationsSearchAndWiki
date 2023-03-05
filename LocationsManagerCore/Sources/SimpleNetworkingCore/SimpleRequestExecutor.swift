//
//  SimpleRequestExecutor.swift
//  
//
//  Created by Sergey Petrachkov
//

import Foundation
import Combine

/// A simple attempt to make the errors strictly typed, meaning that we can see that RequestExecutionError is coming from the "transport" layer and it's not a business logic or something.
public enum RequestExecutionError: Swift.Error {
    case wrappedError(underlyingError: Error)
}

/// This is the simplest and fastest implementation of an entity executing URL requests.
/// By all means, this does not cover all possible cases that can be needed while working with the API (for example: auth challenges are not handled here).
public struct SimpleRequestExecutor {

    private let urlSession: URLSession
    private let decoder: JSONDecoder

    /// Initialize the request executor with the urlSession (maybe already authorized) and a shared JSONDecoder
    public init(urlSession: URLSession, decoder: JSONDecoder) {
        self.urlSession = urlSession
        self.decoder = decoder
    }

    /// Call for resource using async-await feature.
    ///
    /// This uses backported implementation of `urlSession.data` for iOS < 15.0
    public func execute<Response: Decodable>(_ urlRequest: URLRequest) async -> Result<Response, RequestExecutionError> {
        do {
            let response: (Data, URLResponse)
            if #available(iOS 15.0, *) {
                response = try await urlSession.data(for: urlRequest)
            } else {
                response = try await urlSession.backportData(for: urlRequest)
            }
            let decodingResult = try decoder.decode(Response.self, from: response.0)
            return .success(decodingResult)
        } catch {
            return .failure(.wrappedError(underlyingError: error))
        }
    }

    /// Call for resource using Combine
    public func execute<Response: Decodable>(_ urlRequest: URLRequest) -> AnyPublisher<Response, RequestExecutionError> {
        urlSession
            .dataTaskPublisher(for: urlRequest)
            .tryMap { element -> Data in
                element.data
            }
            .decode(type: Response.self, decoder: decoder)
            .catch { Fail(error: RequestExecutionError.wrappedError(underlyingError: $0)) }
            .eraseToAnyPublisher()
    }
}

extension URLSession {
    @available(iOS, deprecated: 15.0, message: "This extension is no longer necessary. Use API built into SDK")
    func backportData(for request: URLRequest) async throws -> (Data, URLResponse) {
        try await withCheckedThrowingContinuation { continuation in
            let task = self.dataTask(with: request) { data, response, error in
                guard let data = data, let response = response else {
                    let error = error ?? URLError(.badServerResponse)
                    return continuation.resume(throwing: error)
                }

                continuation.resume(returning: (data, response))
            }

            task.resume()
        }
    }
}
