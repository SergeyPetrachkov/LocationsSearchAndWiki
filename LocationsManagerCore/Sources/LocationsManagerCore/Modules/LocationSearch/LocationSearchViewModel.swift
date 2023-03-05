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

public protocol LocationSearchViewModelLogic: AnyObject {
    var centerCoordinateTrigger: PassthroughSubject<CLLocationCoordinate2D, Never> { get }
    func cancelSearch()
    func saveSearchResult()
    func showCurrentLocation()
}

@MainActor
public final class LocationSearchViewModel: LocationSearchViewModelLogic, LocationSearchViewModelOutput {

    private let geocoder: Geocoder
    private let coordinatorInput: LocationSearchCoordinatorInput
    private var cancellable: AnyCancellable?
    private var currentTask: Task<(), Never>?

    public let currentLocationSubject: CurrentValueSubject<Location?, Never> = .init(nil)
    public let centerCoordinateTrigger: PassthroughSubject<CLLocationCoordinate2D, Never> = .init()

    public init(geocoder: Geocoder, coordinatorInput: LocationSearchCoordinatorInput) {
        self.geocoder = geocoder
        self.coordinatorInput = coordinatorInput
        cancellable = centerCoordinateTrigger
            .removeDuplicates()
            .debounce(for: 0.3, scheduler: DispatchQueue.main)
            .sink { [weak self] location in
                print("Trigger location change")
                guard let self else {
                    return
                }
                if self.currentTask?.isCancelled ?? false {
                    return
                }
                self.currentTask?.cancel()
                self.currentTask = Task {
                    await self.updateCenterCoordinate(location)
                }
            }
    }

    nonisolated public func saveSearchResult() {

    }

    nonisolated public func cancelSearch() {
        coordinatorInput.didCancelSearch()
    }

    nonisolated public func showCurrentLocation() {
        guard let currentLocation = currentLocationSubject.value else {
            return
        }
        coordinatorInput.show(location: currentLocation)
    }

    private func updateCenterCoordinate(_ coordinate: CLLocationCoordinate2D) async {
        let geocodingResult = await geocoder.reverseGeocode(coordinate: coordinate)

        let location: Location? = {
            guard let geocodingResult else {
                return nil
            }
            return Location(name: geocodingResult.bestName, coordinate: geocodingResult.coordinate)
        }()

        currentLocationSubject.send(location)
    }
}
