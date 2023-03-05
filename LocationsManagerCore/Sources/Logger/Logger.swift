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
    case showLocation(name: String?, coordinate: CLLocationCoordinate2D)

    public var name: String {
        switch self {
        case .fetchLocations:
            return "fetch_locations"
        case .searchLocation:
            return "search_location"
        case .showLocation:
            return "show_location"
        }
    }

    public var parameters: [String: String] {
        switch self {
        case .fetchLocations:
            return [:]
        case .searchLocation:
            return [:]
        case let .showLocation(name, coordinate):
            return ["location_name": name ?? "n/a", "coordinate": "\(coordinate)"]
        }
    }
}

public protocol Logging {
    func log(event: LocationsManagerEvent)
    func log(_ string: String)
    func error(_ error: Error)
}
