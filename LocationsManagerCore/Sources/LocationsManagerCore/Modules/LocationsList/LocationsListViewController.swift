//
//  LocationsListViewController.swift
//  
//
//  Created by Sergey Petrachkov on 05.03.2023.
//

#if canImport(UIKit)
import UIKit
import Combine
import Domain

public final class LocationsListViewController: UIViewController {

    private let viewModel: (LocationsListViewModelOutputEmitting & ViewModelCycle)

    private var cancellables: Set<AnyCancellable> = []

    private lazy var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: makeCollectionLayout())

    private lazy var dataSource: UICollectionViewDiffableDataSource<Int, Location> = {
        let dataSource = UICollectionViewDiffableDataSource<Int, Location>(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, location in
                let cell = collectionView.dequeueReusableCell(for: LocationCell.self, indexPath: indexPath)
                cell.configure(title: location.name ?? "Unknown lands", subtitle: "\(location.coordinate)")
                return cell
            }
        )
        return dataSource
    }()

    public init(viewModel: LocationsListViewModelOutputEmitting & ViewModelCycle) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        makeLayout()
        makeBindings()
        // Task implicitly captures self, but since this is a root screen that cannot be dismissed,
        // we don't really care about the situation where the viewModel is not deallocated until the Task finishes.
        // Otherwise, we can introduce weak capturing and work things out.
        // We also don't store a reference to Task, because it's a simple case without pull-to-refresh or any other concurrent possibilities of fetching data
        Task {
            await viewModel.start()
        }
    }
}

private extension LocationsListViewController {

    func makeCollectionLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(44)
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [item]
        )

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 10,
            leading: 10,
            bottom: 10,
            trailing: 10
        )
        section.interGroupSpacing = 10

        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }

    func makeLayout() {
        title = "Locations" // TODO: Localization
        view.addSubview(collectionView)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = dataSource
        collectionView.register(cellType: LocationCell.self)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                collectionView.topAnchor.constraint(equalTo: view.topAnchor),
                collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            ]
        )
    }
}

extension LocationsListViewController: UICollectionViewDelegate { }

private extension LocationsListViewController {
    func makeBindings() {
        viewModel.locationsSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak dataSource] locations in
                guard let dataSource else { return }
                var snapshot = NSDiffableDataSourceSnapshot<Int, Location>()
                snapshot.appendSections([0])
                snapshot.appendItems(locations[.remote] ?? [], toSection: 0)
                dataSource.apply(snapshot)
            }.store(in: &cancellables)
    }
}
#endif
