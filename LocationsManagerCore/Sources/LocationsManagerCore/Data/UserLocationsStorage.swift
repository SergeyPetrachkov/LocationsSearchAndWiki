//
//  UserLocationsStorage.swift
//  
//
//  Created by Sergey Petrachkov on 05.03.2023.
//

import Foundation

public protocol UserLocationsStoring {
    func getLocations() -> [StorableLocation]
    func saveLocation(_ location: StorableLocation)
}

public struct StorableLocation: Codable {
    public let name: String?
    public let latitude: Double
    public let longitude: Double
}

public final class SimpleUserLocationsStorage: UserLocationsStoring {

    private let key = "user_locations"
    private let defaults: UserDefaults

    public init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    public func getLocations() -> [StorableLocation] {
        defaults.object(forKey: key) as? [StorableLocation] ?? []
    }

    public func saveLocation(_ location: StorableLocation) {
        var existingData = getLocations()
        existingData.append(location)
        let encodedData = try? JSONEncoder().encode(existingData)
        defaults.set(encodedData, forKey: key)
    }
}
