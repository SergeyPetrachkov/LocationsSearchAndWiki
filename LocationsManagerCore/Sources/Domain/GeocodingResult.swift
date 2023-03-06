//
//  GeocodingResult.swift
//  
//
//  Created by Sergey Petrachkov on 05.03.2023.
//

import Foundation
import struct CoreLocation.CLLocationCoordinate2D

/// Most common way to describe geocoding results is here. Most providers give you the same number of fields.
public struct GeocodingResult {
    public let locality: String?
    public let administrativeArea: String?
    public let country: String?
    public let locationName: String?
    public let coordinate: CLLocationCoordinate2D

    public var bestName: String {
        [locality, administrativeArea, country, locationName].compactMap { $0 }.first ?? "Unknown land"
    }

    public init(locality: String? = nil, administrativeArea: String? = nil, country: String? = nil, locationName: String? = nil, coordinate: CLLocationCoordinate2D) {
        self.locality = locality
        self.administrativeArea = administrativeArea
        self.country = country
        self.locationName = locationName
        self.coordinate = coordinate
    }
}
