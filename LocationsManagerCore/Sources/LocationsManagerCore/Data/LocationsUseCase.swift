//
//  LocationsUseCase.swift
//  
//
//  Created by Sergey Petrachkov on 05.03.2023.
//

import Foundation
import Logger
import LocationsManagerAPI
import Domain
import Combine

/// A way to categorise locations by their origin (remote or coming from a server and ones coming from user's search)
public enum LocationOrigin: Int {
    case userSearch = 0
    case remote
}

public protocol LocationsUseCaseLogic {
    var userSavedLocationPublisher: PassthroughSubject<Location, Never> { get }
    func fetchLocations() async -> [LocationOrigin: [Location]]
    func saveLocation(_ location: Location)
}

/// This entity manages locations related logic.
///
/// It talks to a server (Github in our case), it also talks to our local storage. And it also provides a way to subscribe to user stored locations channel.
public final class LocationsUseCase: LocationsUseCaseLogic {

    private let logger: Logging
    private let api: LocationsManagerAPIProviding
    private let userLocationsStorage: UserLocationsStoring
    private var cancellables: Set<AnyCancellable> = []

    public let userSavedLocationPublisher: PassthroughSubject<Location, Never> = .init()

    public init(logger: Logging, api: LocationsManagerAPIProviding, userLocationsStorage: UserLocationsStoring) {
        self.logger = logger
        self.api = api
        self.userLocationsStorage = userLocationsStorage
        userLocationsStorage
            .newLocationPublisher
            .sink { [weak self] storedLocation in
                self?.userSavedLocationPublisher.send(Location(from: storedLocation))
            }
            .store(in: &cancellables)
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

    public func saveLocation(_ location: Location) {
        userLocationsStorage.saveLocation(StorableLocation(from: location))
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

private extension StorableLocation {
    init(from location: Location) {
        self.init(name: location.name, latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
    }
}
