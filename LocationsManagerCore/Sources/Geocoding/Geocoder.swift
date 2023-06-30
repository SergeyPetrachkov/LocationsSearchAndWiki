//
//  Geocoder.swift
//  
//
//  Created by Sergey Petrachkov on 05.03.2023.
//

import CoreLocation
import Domain
import SiberianMacros

/// A simple protocol that should define an interface for geocoding-related work in a way, so geocoders can be interchangeable.
@AutoMockable
public protocol Geocoder {
    /// Get a place from mere coordinates
    func reverseGeocode(coordinate: CLLocationCoordinate2D) async -> GeocodingResult?
    /// Get a place with coordinates from just a string
    func forwardGeocoder(searchTerm: String) async -> GeocodingResult?
}
