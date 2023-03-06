//
//  LocationsManagerEvent.swift
//  
//
//  Created by Sergey Petrachkov on 06.03.2023.
//

import Foundation
import struct CoreLocation.CLLocationCoordinate2D

public enum LocationsManagerEvent {

    public enum ShowLocationEventOrigin: String {
        case list
        case search
    }

    case fetchLocations
    case searchCoordinate(coordinate: CLLocationCoordinate2D)
    case searchLocationByName(searchTerm: String)
    case showLocation(name: String?, coordinate: CLLocationCoordinate2D, origin: ShowLocationEventOrigin)

    public var name: String {
        switch self {
        case .fetchLocations:
            return "fetch_locations"
        case .searchCoordinate:
            return "search_coordinate"
        case .searchLocationByName:
            return "search_location_by_name"
        case .showLocation:
            return "show_location"
        }
    }

    public var parameters: [String: String] {
        switch self {
        case .fetchLocations:
            return [:]
        case let .searchCoordinate(coordinate):
            return ["coordinate": "\(coordinate)"]
        case let .searchLocationByName(searchTerm):
            return ["search_term": searchTerm]
        case let .showLocation(name, coordinate, origin):
            return ["location_name": name ?? "n/a", "coordinate": "\(coordinate)", "origin": origin.rawValue]
        }
    }
}
