//
//  AppDependencies.swift
//  LocationsManager
//
//  Created by Sergey Petrachkov on 05.03.2023.
//

import LocationsManagerCore
import LocationsManagerAPI
import Logger

final class AppDependencies: DependencyContaining {

    let logger: Logging = UnitedLogs()

    func locationsApi() -> LocationsManagerAPIProviding {
        LocationsManagerAPI(urlSession: .shared)
    }

    func locationsRepository() -> LocationsRepositoryLogic {
        LocationsRepository(logger: logger, api: locationsApi(), userLocationsStorage: SimpleUserLocationsStorage())
    }
}
