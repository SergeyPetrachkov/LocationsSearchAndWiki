//
//  UserLocationsStorage.swift
//  
//
//  Created by Sergey Petrachkov on 05.03.2023.
//

import Foundation
import Combine

/// This is a storage level entity, describing a location. It looks like API DTO, but belongs to "database" layer.
public struct StorableLocation: Codable, Equatable {
    public let name: String?
    public let latitude: Double
    public let longitude: Double
}

/// An abstraction for a storage of locations with an output that emits newly saved location events
public protocol UserLocationsStoring {
    /// Emit newly saved location. Inspired by Realm observers.
    var newLocationPublisher: PassthroughSubject<StorableLocation, Never> { get }
    /// Get the stored locations
    func getLocations() -> [StorableLocation]
    /// Save a location to the storage
    func saveLocation(_ location: StorableLocation)
}

/// Simple UserDefaults based implementation. Not secure, just quick and dirty.
public final class SimpleUserLocationsStorage: UserLocationsStoring {

    private let key = "user_locations"
    private let defaults: UserDefaults

    public let newLocationPublisher: PassthroughSubject<StorableLocation, Never> = .init()

    public init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    public func getLocations() -> [StorableLocation] {
        guard let data = defaults.data(forKey: key) else {
            return []
        }
        let decoded = (try? JSONDecoder().decode([StorableLocation].self, from: data)) ?? []
        return decoded
    }

    public func saveLocation(_ location: StorableLocation) {
        var existingData = getLocations()
        guard !existingData.contains(where: { $0 == location }) else {
            return
        }
        existingData.append(location)
        let encodedData = try? JSONEncoder().encode(existingData)
        defaults.set(encodedData, forKey: key)
        newLocationPublisher.send(location)
    }
}
