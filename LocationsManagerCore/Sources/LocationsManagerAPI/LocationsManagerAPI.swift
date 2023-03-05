//
//  LocationsManagerAPI.swift
//  
//
//  Created by Sergey Petrachkov on 05.03.2023.
//

import Foundation
import SimpleNetworkingCore

public protocol LocationsManagerAPIProviding {
    func fetchLocations() async -> Result<LocationsResponse, RequestExecutionError>
}

public final class LocationsManagerAPI: LocationsManagerAPIProviding {

    private let urlSession: URLSession
    private let decoder: JSONDecoder

    public init(urlSession: URLSession, decoder: JSONDecoder = JSONDecoder()) {
        self.urlSession = urlSession
        self.decoder = decoder
    }

    public func fetchLocations() async -> Result<LocationsResponse, RequestExecutionError> {
        let request: APIEndpoint<LocationsResponse> = .locations()
        let executor = SimpleRequestExecutor(urlSession: urlSession, decoder: decoder)
        return await executor.execute(request.asURLRequest())
    }
}
