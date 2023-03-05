//
//  Location.swift
//  
//
//  Created by Sergey Petrachkov on 05.03.2023.
//

import Foundation
import struct CoreLocation.CLLocationCoordinate2D

public struct Location {
    public let name: String?
    public let coordinate: CLLocationCoordinate2D

    public init(name: String? = nil, coordinate: CLLocationCoordinate2D) {
        self.name = name
        self.coordinate = coordinate
    }
}

public extension Location {
    init(name: String? = nil, latitude: Double, longitude: Double) {
        self.name = name
        self.coordinate = .init(latitude: latitude, longitude: longitude)
    }
}

extension CLLocationCoordinate2D: Equatable, Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(latitude)
        hasher.combine(longitude)
    }

    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}

extension Location: Hashable {
    public static func == (lhs: Location, rhs: Location) -> Bool {
        lhs.name == rhs.name && lhs.coordinate == rhs.coordinate
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(coordinate)
    }
}
