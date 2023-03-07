//
//  LocationSearchViewModelOutput.swift
//  
//
//  Created by Sergey Petrachkov on 05.03.2023.
//

import Foundation
import Combine
import Domain

/// Simple way to get strongly typed errors for geocoder
public enum GeocodingError: Error, LocalizedError {
    case failedReverseGeocoding
    case failedForwardGeocoding

    public var errorDescription: String? {
        localizedDescription
    }

    // TODO: Localization
    public var localizedDescription: String {
        switch self {
        case .failedReverseGeocoding:
            return "Failed to look up the specified coordinates! Try some other location."
        case .failedForwardGeocoding:
            return "Failed to look up the specified search term! Try typing in something else."
        }
    }
}

public protocol LocationSearchViewModelOutput {
    var currentLocationSubject: CurrentValueSubject<Location?, Never> { get }
    var loadingSubject: PassthroughSubject<Bool, Never> { get }
    var geocodingErrorSubject: PassthroughSubject<GeocodingError, Never> { get }
}
