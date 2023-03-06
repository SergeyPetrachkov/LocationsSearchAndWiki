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
    // TODO: Some strongly typed images would be better. Something with Swiftgen for example.
    private lazy var pinView: UIImageView = UIImageView(image: UIImage(systemName: "mappin", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34)))

    private lazy var resultsView = ActionableLocationView(frame: .zero)

    private lazy var searchBar: UISearchBar = {
        let view = UISearchBar(frame: .zero)
        view.delegate = self
        view.backgroundColor = .clear
        view.placeholder = "Search" // TODO: Localization
        return view
    }()
    // TODO: This one should be within another view that would be built on top of ActionableLocationView
    private lazy var progressView = UIActivityIndicatorView(style: .medium)

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

extension LocationSearchViewController: UISearchBarDelegate {

    public func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }

    public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }

    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let text = searchBar.text else {
            return
        }
        viewModel.textSearchTrigger.send(text)
    }

    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
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

        view.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(progressView)
        progressView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate(
            [
                mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                mapView.topAnchor.constraint(equalTo: view.topAnchor),
                mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

                searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                searchBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 55),
                searchBar.heightAnchor.constraint(equalToConstant: 44),

                pinView.centerXAnchor.constraint(equalTo: mapView.centerXAnchor),
                pinView.centerYAnchor.constraint(equalTo: mapView.centerYAnchor),

                progressView.centerXAnchor.constraint(equalTo: resultsView.centerXAnchor),
                progressView.centerYAnchor.constraint(equalTo: resultsView.centerYAnchor),

                resultsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                resultsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                resultsView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -10),
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
                self?.searchBar.text = currentLocation.name
                // TODO: Localization + Unkwnon lands is scattered around the project, which is not good, but for the sake of simplicity it'll do
                self?.resultsView.configure(title: currentLocation.name ?? "Unknown lands", subtitle: currentLocation.readableCoordinates)
            }
            .store(in: &cancellables)

        viewModel
            .loadingSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.progressView.startAnimating()
                } else {
                    self?.progressView.stopAnimating()
                }
                self?.progressView.isHidden = !isLoading
            }
            .store(in: &cancellables)
    }

    @objc
    func didTapSave() {
        viewModel.saveSearchResult()
    }

    @objc
    func didTapCancel() {
        viewModel.cancelSearch()
    }

    @objc
    func didTapLocation() {
        viewModel.showCurrentLocation()
    }
}
#endif
