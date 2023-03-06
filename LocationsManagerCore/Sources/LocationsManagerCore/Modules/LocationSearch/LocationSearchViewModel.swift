//
//  LocationSearchViewModel.swift
//  
//
//  Created by Sergey Petrachkov on 05.03.2023.
//

import Foundation
import CoreLocation
import Domain
import Combine
import Geocoding
import Logger

/// An interface to manipulating an instance of `LocationSearchViewModel`
public protocol LocationSearchViewModelLogic: AnyObject {
    /// The interface for map interactions. Map center changes, we trigger it.
    var centerCoordinateTrigger: PassthroughSubject<CLLocationCoordinate2D, Never> { get }
    /// The interface for the textual search. The user taps "search", we trigger it.
    var textSearchTrigger: PassthroughSubject<String, Never> { get }
    /// Proxy method to pass to Coordinator that we need to close the screen.
    func cancelSearch()
    /// Trigger the current location saving logic.
    func saveSearchResult()
    /// Proxy method to pass to Coordinator that we need to show the current location.
    func showCurrentLocation()
}

/// An implementation of `LocationSearchViewModelLogic` that also conforms to `LocationSearchViewModelOutput`
public final class LocationSearchViewModel: LocationSearchViewModelLogic, LocationSearchViewModelOutput {

    // MARK: - Private dependencies
    private let geocoder: Geocoder
    private let logger: Logging
    private let locationsUseCase: LocationsUseCaseLogic
    private let coordinatorInput: LocationSearchCoordinatorInput
    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Connectors
    public let currentLocationSubject: CurrentValueSubject<Location?, Never> = .init(nil)
    public let centerCoordinateTrigger: PassthroughSubject<CLLocationCoordinate2D, Never> = .init()
    public let textSearchTrigger: PassthroughSubject<String, Never> = .init()
    public let loadingSubject: PassthroughSubject<Bool, Never> = .init()

    // MARK: - Init

    public init(geocoder: Geocoder, logger: Logging, locationsUseCase: LocationsUseCaseLogic, coordinatorInput: LocationSearchCoordinatorInput) {
        self.geocoder = geocoder
        self.logger = logger
        self.locationsUseCase = locationsUseCase
        self.coordinatorInput = coordinatorInput

        centerCoordinateTrigger
            .removeDuplicates()
            .debounce(for: 0.3, scheduler: DispatchQueue.main)
            .sink { [weak self] location in
                guard let self else {
                    return
                }
                Task {
                    await self.updateCenterCoordinate(location)
                }
            }
            .store(in: &cancellables)

        textSearchTrigger
            .removeDuplicates()
            .debounce(for: 0.3, scheduler: DispatchQueue.main)
            .sink { [weak self] searchTerm in
                guard let self else {
                    return
                }
                Task {
                    await self.searchLocation(by: searchTerm)
                }
            }
            .store(in: &cancellables)
    }

    // MARK: - Public methods
    public func saveSearchResult() {
        guard let currentLocation = currentLocationSubject.value else {
            return
        }
        locationsUseCase.saveLocation(currentLocation)
    }

    public func cancelSearch() {
        coordinatorInput.didCancelSearch()
    }

    public func showCurrentLocation() {
        guard let currentLocation = currentLocationSubject.value else {
            return
        }
        coordinatorInput.show(location: currentLocation)
    }
}

// MARK: - Private stuff
private extension LocationSearchViewModel {

    func updateCenterCoordinate(_ coordinate: CLLocationCoordinate2D) async {
        logger.log(event: .searchCoordinate(coordinate: coordinate))
        defer {
            loadingSubject.send(false)
        }
        loadingSubject.send(true)
        let geocodingResult = await geocoder.reverseGeocode(coordinate: coordinate)
        updateCurrentLocation(from: geocodingResult)
    }

    func searchLocation(by searchTerm: String) async {
        logger.log(event: .searchLocationByName(searchTerm: searchTerm))
        defer {
            loadingSubject.send(false)
        }
        loadingSubject.send(true)
        let geocodingResult = await geocoder.forwardGeocoder(searchTerm: searchTerm)
        updateCurrentLocation(from: geocodingResult)
    }

    /// Try to update the current location from given geocoding result.
    ///
    /// If the geocoding failed, the current location won't be updated and the old value will remain.
    private func updateCurrentLocation(from geocodingResult: GeocodingResult?) {
        let location: Location? = {
            guard let geocodingResult else {
                return nil
            }
            return Location(name: geocodingResult.bestName, coordinate: geocodingResult.coordinate)
        }()

        if let location {
            currentLocationSubject.send(location)
        } else {
            let previousValue = currentLocationSubject.value
            currentLocationSubject.send(previousValue)
        }
    }
}
