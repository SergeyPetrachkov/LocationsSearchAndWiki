//
//  AppDependencies.swift
//  LocationsManager
//
//  Created by Sergey Petrachkov on 05.03.2023.
//

import LocationsManagerCore
import LocationsManagerAPI
import Logger
import Geocoding

/// Container that holds dependencies for the app and defines their scopes
final class AppDependencies: DependencyContaining {
    // MARK: - App scope dependencies
    let logger: Logging = UnitedLogs()
    lazy var locationsUsecase: LocationsUseCaseLogic = LocationsUseCase(logger: logger, api: locationsApi(), userLocationsStorage: SimpleUserLocationsStorage())

    // MARK: - Factories for screen scoped objects
    func locationsApi() -> LocationsManagerAPIProviding {
        LocationsManagerAPI(urlSession: .shared)
    }

    func geocoder() -> Geocoder {
        AppleGeocoder()
    }

    func externalCoordinator(navigationSeed: NavigationSeed) -> ExternalCoordinator {
        WikiAppCoordinator(logger: logger, origin: navigationSeed)
    }
}
