//
//  LocationSearchViewController.swift
//  
//
//  Created by Sergey Petrachkov on 05.03.2023.
//

#if canImport(UIKit)
import UIKit
import MapKit

public final class LocationSearchViewController: UIViewController {
    // MARK: - UI components
    private let mapView = MKMapView()

    // MARK: - Private props
    private let viewModel: LocationSearchViewModelLogic
    // MARK: - Initializers
    public init(viewModel: LocationSearchViewModelLogic) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        print("☢️ \(self) deinit")
    }
    // MARK: - Life cycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        makeLayout()
    }
}

private extension LocationSearchViewController {
    func makeLayout() {
        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate(
            [
                mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                mapView.topAnchor.constraint(equalTo: view.topAnchor),
                mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            ]
        )
    }
}
#endif
