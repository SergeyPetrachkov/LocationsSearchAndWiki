//
//  LocationsRepository.swift
//  
//
//  Created by Sergey Petrachkov on 05.03.2023.
//

import Foundation
import Logger
import LocationsManagerAPI
import Domain

public enum LocationOrigin: Int {
    case userSearch = 0
    case remote
}

public protocol LocationsRepositoryLogic {
    func fetchLocations() async -> [LocationOrigin: [Location]]
}

public final class LocationsRepository: LocationsRepositoryLogic {

    private let logger: Logging
    private let api: LocationsManagerAPIProviding
    private let userLocationsStorage: UserLocationsStoring

    public init(logger: Logging, api: LocationsManagerAPIProviding, userLocationsStorage: UserLocationsStoring) {
        self.logger = logger
        self.api = api
        self.userLocationsStorage = userLocationsStorage
    }

    public func fetchLocations() async -> [LocationOrigin: [Location]] {
        logger.log(event: .fetchLocations)
        var result = [LocationOrigin: [Location]]()
        let userLocations = userLocationsStorage.getLocations().map(Location.init(from:))
        result[.userSearch, default: []].append(contentsOf: userLocations)
        let fetchResult = await api.fetchLocations()
        switch fetchResult {
        case .success(let locationsContainer):
            let remoteLocations = locationsContainer.locations.map(Location.init(from:))
            result[.remote, default: []].append(contentsOf: remoteLocations)
        case .failure(let failure):
            logger.error(failure)
            return [:]
        }
        return result
    }
}

private extension Location {
    init(from dto: LocationDTO) {
        self.init(name: dto.name, latitude: dto.lat, longitude: dto.long)
    }

    init(from local: StorableLocation) {
        self.init(name: local.name, latitude: local.latitude, longitude: local.longitude)
    }
}
