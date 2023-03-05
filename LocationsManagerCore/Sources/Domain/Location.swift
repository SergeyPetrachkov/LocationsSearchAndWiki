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

    /// This is a simple conversion from raw lat/long to something more user-friendly.
    ///
    /// **Important:**
    /// This can/should reside in a separate entity, but for the sake of simplicity I put it here.
    ///
    /// P.S. this method does not normalize overflown coordinates like 420, 370, etc.
    public var readableCoordinates: String {
        var latSeconds = Int(coordinate.latitude * 3600)
        let latDegrees = latSeconds / 3600
        latSeconds = abs(latSeconds % 3600)
        let latMinutes = latSeconds / 60
        latSeconds %= 60

        var lonSeconds = Int(coordinate.longitude * 3600)
        let lonDegrees = lonSeconds / 3600
        lonSeconds = abs(lonSeconds % 3600)
        let lonMinutes = lonSeconds / 60
        lonSeconds %= 60

        return "\(abs(latDegrees))°\(latMinutes)'\(latDegrees >= 0 ? "N" : "S") \(abs(lonDegrees))°\(lonMinutes)'\(lonDegrees >= 0 ? "E" : "W")"
    }

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
