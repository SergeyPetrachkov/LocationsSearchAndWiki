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

    init(rootNavigationController: UINavigationController) {
        self.rootNavigationController = rootNavigationController
    }

    func start() {
        let locationsRepo = LocationsRepository(logger: OSLogger(), api: LocationsManagerAPI(urlSession: URLSession.shared))
        let locationsViewModel = LocationsListViewModel(locationsRepository: locationsRepo)
        let viewController = LocationsListViewController(viewModel: locationsViewModel)
        rootNavigationController.setViewControllers([viewController], animated: true)
    }
}
