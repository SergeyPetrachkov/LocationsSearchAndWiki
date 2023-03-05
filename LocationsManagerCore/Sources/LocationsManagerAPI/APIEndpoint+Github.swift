//
//  APIEndoint+Github.swift
//  
//
//  Created by Sergey Petrachkov on 05.03.2023.
//

import Foundation
import SimpleNetworkingCore

extension APIEndpoint {
    static func locations() -> APIEndpoint<LocationsResponse> {
        APIEndpoint<LocationsResponse>(path: "https://raw.githubusercontent.com/abnamrocoesd/assignment-ios/main/locations.json", customHeaders: nil)
    }
}
