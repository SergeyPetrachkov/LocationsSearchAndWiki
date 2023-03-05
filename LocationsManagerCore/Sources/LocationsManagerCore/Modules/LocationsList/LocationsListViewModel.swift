//
//  LocationsListViewModel.swift
//  
//
//  Created by Sergey Petrachkov on 05.03.2023.
//

import Foundation
import Combine
import Domain

@MainActor
public final class LocationsListViewModel: ViewModelCycle, LocationsListViewModelOutputEmitting {

    // MARK: - Private props
    private let locationsRepository: LocationsRepositoryLogic

    // MARK: - Output connectors
    public let locationsSubject: CurrentValueSubject<[LocationOrigin : [Location]], Never> = .init([:])
    public let loadingSubject: PassthroughSubject<Bool, Never> = .init()
    public let errorSubject: PassthroughSubject<Error, Never> = .init()

    // MARK: - Init
    public init(locationsRepository: LocationsRepositoryLogic) {
        self.locationsRepository = locationsRepository
    }

    // MARK: - Class Interface
    public func start() async {
        defer {
            loadingSubject.send(false)
        }
        loadingSubject.send(true)
        let locations = await locationsRepository.fetchLocations()
        locationsSubject.send(locations)
    }

    public func pause() async {

    }
}
