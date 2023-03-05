//
//  LocationsListViewModel.swift
//  
//
//  Created by Sergey Petrachkov on 05.03.2023.
//

import Foundation
import Combine
import Domain

public protocol LocationsListViewModelLogic: AnyObject, ViewModelCycle {
    func startSearch() async
    func showLocation(section: Int, row: Int)
}

@MainActor
public final class LocationsListViewModel: LocationsListViewModelLogic, LocationsListViewModelOutputEmitting {

    // MARK: - Private props
    private let locationsRepository: LocationsRepositoryLogic
    private let coordinatorInput: LocationsListCoordinatorInput

    // MARK: - Output connectors
    public let locationsSubject: CurrentValueSubject<[LocationOrigin : [Location]], Never> = .init([:])
    public let loadingSubject: PassthroughSubject<Bool, Never> = .init()
    public let errorSubject: PassthroughSubject<Error, Never> = .init()

    // MARK: - Init
    public init(locationsRepository: LocationsRepositoryLogic, coordinatorInput: LocationsListCoordinatorInput) {
        self.locationsRepository = locationsRepository
        self.coordinatorInput = coordinatorInput
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

    public func pause() async { }

    public func startSearch() async {
        coordinatorInput.didTriggerLocationSearch()
    }

    nonisolated public func showLocation(section: Int, row: Int) {
        guard let strongTypedSection = LocationOrigin(rawValue: section),
              let locationsArray = locationsSubject.value[strongTypedSection],
              locationsArray.count > row else {
            return
        }
        let location = locationsArray[row]
        coordinatorInput.show(location: location)
    }
}
