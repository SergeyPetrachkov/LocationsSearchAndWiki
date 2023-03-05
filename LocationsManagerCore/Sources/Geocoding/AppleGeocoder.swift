//
//  AppleGeocoder.swift
//  
//
//  Created by Sergey Petrachkov on 05.03.2023.
//

import Foundation
import Domain
import CoreLocation

/// This is an adapter for Apple geocoder  that communicates with CLGeocoder and wraps result into our `GeocodingResult`
public final class AppleGeocoder: Geocoder {

    private let geocoder: CLGeocoder

    public init(geocoder: CLGeocoder = CLGeocoder()) {
        self.geocoder = geocoder
    }

    public func reverseGeocode(coordinate: CLLocationCoordinate2D) async -> GeocodingResult? {
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        guard let result = try? await geocoder.reverseGeocodeLocation(location).first, let coordinate = result.location?.coordinate else {
            return nil
        }
        return GeocodingResult(locality: result.locality, administrativeArea: result.administrativeArea, country: result.country, locationName: result.name, coordinate: coordinate)
    }

    public func forwardGeocoder(searchTerm: String) async -> GeocodingResult? {
        guard let result = try? await geocoder.geocodeAddressString(searchTerm).first, let coordinate = result.location?.coordinate else {
            return nil
        }
        return GeocodingResult(locality: result.locality, administrativeArea: result.administrativeArea, country: result.country, locationName: result.name, coordinate: coordinate)
    }
}
