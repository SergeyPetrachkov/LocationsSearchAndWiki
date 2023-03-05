//
//  LocationSearchViewController.swift
//  
//
//  Created by Sergey Petrachkov on 05.03.2023.
//

#if canImport(UIKit)
import UIKit
import MapKit
import Combine

public final class LocationSearchViewController: UIViewController {
    // MARK: - UI components
    private lazy var mapView = MKMapView()
    private lazy var pinView: UIImageView = UIImageView(image: UIImage(systemName: "mappin", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34)))
    private lazy var resultsView = LocationView(frame: .zero)

    // MARK: - Private props
    private let viewModel: LocationSearchViewModelLogic & LocationSearchViewModelOutput
    private var cancellables: Set<AnyCancellable> = []
    // MARK: - Initializers
    public init(viewModel: LocationSearchViewModelLogic & LocationSearchViewModelOutput) {
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
        makeBindings()
    }
}

extension LocationSearchViewController: MKMapViewDelegate {
    public func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        viewModel.centerCoordinateTrigger.send(mapView.centerCoordinate)
    }
}

private extension LocationSearchViewController {
    func makeLayout() {

        navigationItem.rightBarButtonItem = .init(barButtonSystemItem: .save, target: self, action: #selector(didTapSave))
        navigationItem.leftBarButtonItem = .init(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancel))

        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.delegate = self

        view.addSubview(pinView)
        pinView.translatesAutoresizingMaskIntoConstraints = false
        pinView.tintColor = .red

        view.addSubview(resultsView)
        resultsView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate(
            [
                mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                mapView.topAnchor.constraint(equalTo: view.topAnchor),
                mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

                pinView.centerXAnchor.constraint(equalTo: mapView.centerXAnchor),
                pinView.centerYAnchor.constraint(equalTo: mapView.centerYAnchor),

                resultsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                resultsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                resultsView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -44),
                resultsView.heightAnchor.constraint(greaterThanOrEqualToConstant: 60),
            ]
        )

        resultsView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapLocation)))
    }

    func makeBindings() {
        viewModel
            .currentLocationSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] currentLocation in
                guard let currentLocation = currentLocation else {
                    return
                }
                self?.mapView.setCenter(currentLocation.coordinate, animated: true)
                self?.resultsView.configure(title: currentLocation.name ?? "Unknown lands", subtitle: currentLocation.readableCoordinates)
            }
            .store(in: &cancellables)
    }

    @objc
    private func didTapSave() {
        viewModel.saveSearchResult()
    }

    @objc
    private func didTapCancel() {
        viewModel.cancelSearch()
    }

    @objc
    private func didTapLocation() {
        viewModel.showCurrentLocation()
    }
}
#endif
