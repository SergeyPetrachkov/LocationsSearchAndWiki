//
//  Logger.swift
//  
//
//  Created by Sergey Petrachkov on 05.03.2023.
//

import Foundation
import struct CoreLocation.CLLocationCoordinate2D

public enum LocationsManagerEvent {
    case fetchLocations
    case searchLocation(coordinate: CLLocationCoordinate2D)

    public var name: String {
        switch self {
        case .fetchLocations:
            return "fetch_locations"
        case .searchLocation:
            return "search_location"
        }
    }

    public var parameters: [String: String] {
        switch self {
        case .fetchLocations:
            return [:]
        case .searchLocation:
            return [:]
        }
    }
}

public protocol Logging {
    func log(event: LocationsManagerEvent)
    func log(_ string: String)
    func error(_ error: Error)
}
