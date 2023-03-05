//
//  AppCoordinator.swift
//  LocationsManager
//
//  Created by Sergey Petrachkov on 05.03.2023.
//

import UIKit
import LocationsManagerCore
import Logger
import LocationsManagerAPI

@MainActor
final class AppCoordinator {

    private let rootNavigationController: UINavigationController
    private let dependenciesContainer: DependencyContaining

    init(rootNavigationController: UINavigationController, dependenciesContainer: DependencyContaining) {
        self.rootNavigationController = rootNavigationController
        self.dependenciesContainer = dependenciesContainer
    }

    func start() {
        let locationsListCoordinator = LocationsListCoordinator(navigationController: rootNavigationController, dependenciesContainer: dependenciesContainer)
        locationsListCoordinator.start()
    }
}
