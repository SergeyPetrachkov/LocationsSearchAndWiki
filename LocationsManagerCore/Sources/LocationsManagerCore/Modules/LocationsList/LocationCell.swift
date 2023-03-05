//
//  LocationCell.swift
//  
//
//  Created by Sergey Petrachkov on 05.03.2023.
//

#if canImport(UIKit)
import UIKit

public final class LocationCell: UICollectionViewCell {
    // MARK: - UI components
    private lazy var locationView = LocationView(frame: .zero)

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Class interface
    func configure(title: String, subtitle: String) {
        locationView.configure(title: title, subtitle: subtitle)
    }
}

// MARK: - Private logic
private extension LocationCell {
    func configureViews() {
        contentView.addSubview(locationView)
        locationView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate(
            [
                locationView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                locationView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                locationView.topAnchor.constraint(equalTo: contentView.topAnchor),
                locationView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            ]
        )
    }
}
#endif
