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
    case userSearch
    case remote
}

public protocol LocationsRepositoryLogic {
    func fetchLocations() async -> [LocationOrigin: [Location]]
}

public final class LocationsRepository: LocationsRepositoryLogic {

    private let logger: Logging
    private let api: LocationsManagerAPIProviding

    public init(logger: Logging, api: LocationsManagerAPIProviding) {
        self.logger = logger
        self.api = api
    }

    public func fetchLocations() async -> [LocationOrigin: [Location]] {
        logger.log(event: .fetchLocations)
        let fetchResult = await api.fetchLocations()
        switch fetchResult {
        case .success(let locationsContainer):
            let remoteLocations = locationsContainer.locations.map(Location.init(from:))
            return [.remote: remoteLocations]
        case .failure(let failure):
            logger.error(failure)
            return [:]
        }
    }
}

private extension Location {
    init(from dto: LocationDTO) {
        self.init(name: dto.name, latitude: dto.lat, longitude: dto.long)
    }
}
