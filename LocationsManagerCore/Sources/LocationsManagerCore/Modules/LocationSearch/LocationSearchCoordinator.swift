//
//  LocationSearchCoordinator.swift
//  
//
//  Created by Sergey Petrachkov on 05.03.2023.
//

#if canImport(UIKit)
import UIKit

@MainActor
public final class LocationSearchCoordinator {

    private let navigationController: UINavigationController

    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewModel = LocationSearchViewModel()
        let viewController = UINavigationController(rootViewController: LocationSearchViewController(viewModel: viewModel))
        navigationController.present(viewController, animated: true)
    }
}
#endif
