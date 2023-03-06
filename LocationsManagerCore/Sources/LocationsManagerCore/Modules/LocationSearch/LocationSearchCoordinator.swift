//
//  LocationSearchCoordinator.swift
//  
//
//  Created by Sergey Petrachkov on 05.03.2023.
//

import Domain

public protocol LocationSearchCoordinatorInput: AnyObject, ExternalCoordinator {
    func didCancelSearch()
}

#if canImport(UIKit)
import UIKit

@MainActor
public final class LocationSearchCoordinator: NavigationSeedHolder {

    private let navigationController: UINavigationController
    private let dependenciesContainer: DependencyContaining

    public let navigationSeed: NavigationSeed = .locationSearch

    public init(navigationController: UINavigationController, dependenciesContainer: DependencyContaining) {
        self.navigationController = navigationController
        self.dependenciesContainer = dependenciesContainer
    }

    func start() {
        let viewModel = LocationSearchViewModel(
            geocoder: dependenciesContainer.geocoder(),
            logger: dependenciesContainer.logger,
            locationsUseCase: dependenciesContainer.locationsUsecase,
            coordinatorInput: self
        )
        let viewController = LocationSearchViewController(viewModel: viewModel)
        let wrapperController = UINavigationController(rootViewController: viewController)
        wrapperController.navigationBar.backgroundColor = .white
        navigationController.present(wrapperController, animated: true)
    }
}

extension LocationSearchCoordinator: LocationSearchCoordinatorInput {
    public func didCancelSearch() {
        navigationController.presentedViewController?.dismiss(animated: true)
    }

    public func show(location: Location) {
        dependenciesContainer.externalCoordinator(navigationSeed: navigationSeed).show(location: location)
    }
}
#endif
