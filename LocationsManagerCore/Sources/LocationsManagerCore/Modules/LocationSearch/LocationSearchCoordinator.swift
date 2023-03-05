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
public final class LocationSearchCoordinator {

    private let navigationController: UINavigationController
    private let dependenciesContainer: DependencyContaining

    public init(navigationController: UINavigationController, dependenciesContainer: DependencyContaining) {
        self.navigationController = navigationController
        self.dependenciesContainer = dependenciesContainer
    }

    func start() {
        let viewModel = LocationSearchViewModel(geocoder: dependenciesContainer.geocoder(), coordinatorInput: self)
        let viewController = UINavigationController(rootViewController: LocationSearchViewController(viewModel: viewModel))
        navigationController.present(viewController, animated: true)
    }
}

extension LocationSearchCoordinator: LocationSearchCoordinatorInput {
    public func didCancelSearch() {
        navigationController.presentedViewController?.dismiss(animated: true)
    }

    public func show(location: Location) {
        dependenciesContainer.externalCoordinator().show(location: location)
    }
}
#endif
