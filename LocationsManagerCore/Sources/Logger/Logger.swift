//
//  Logger.swift
//  
//
//  Created by Sergey Petrachkov on 05.03.2023.
//

import Foundation

public enum LocationsManagerEvent {
    case fetchLocations

    public var name: String {
        switch self {
        case .fetchLocations:
            return "fetch_locations"
        }
    }
}

public protocol Logging {
    func log(event: LocationsManagerEvent)
    func log(_ string: String)
    func error(_ error: Error)
}
