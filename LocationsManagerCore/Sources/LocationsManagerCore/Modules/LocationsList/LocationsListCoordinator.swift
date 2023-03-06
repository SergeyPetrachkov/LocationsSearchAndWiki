//
//  LocationsListCoordinator.swift
//  
//
//  Created by Sergey Petrachkov on 05.03.2023.
//

import Domain

public protocol LocationsListCoordinatorInput: AnyObject, ExternalCoordinator {
    func didTriggerLocationSearch()
}

#if canImport(UIKit)
import UIKit

@MainActor
public final class LocationsListCoordinator {
    private let navigationController: UINavigationController
    private let dependenciesContainer: DependencyContaining

    public init(navigationController: UINavigationController, dependenciesContainer: DependencyContaining) {
        self.navigationController = navigationController
        self.dependenciesContainer = dependenciesContainer
    }

    public func start() {
        let viewModel = LocationsListViewModel(locationsRepository: dependenciesContainer.locationsRepository(), coordinatorInput: self)
        let viewController = LocationsListViewController(viewModel: viewModel)
        navigationController.setViewControllers([viewController], animated: true)
    }
}

extension LocationsListCoordinator: LocationsListCoordinatorInput {
    public func didTriggerLocationSearch() {
        let locationSearchCoordinator = LocationSearchCoordinator(navigationController: navigationController, dependenciesContainer: dependenciesContainer)
        locationSearchCoordinator.start()
    }

    public func show(location: Location) {
        dependenciesContainer.externalCoordinator().show(location: location)
    }
}
#endif