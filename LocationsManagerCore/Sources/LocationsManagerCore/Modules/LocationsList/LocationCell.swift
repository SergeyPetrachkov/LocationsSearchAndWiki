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
    private lazy var titleView: UILabel = {
        let view = UILabel(frame: .zero)
        view.font = .preferredFont(forTextStyle: .headline)
        view.numberOfLines = 2
        return view
    }()

    private lazy var coordinatesView: UILabel = {
        let view = UILabel(frame: .zero)
        view.font = .preferredFont(forTextStyle: .subheadline)
        view.numberOfLines = 2
        return view
    }()

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
        titleView.text = title
        coordinatesView.text = subtitle
    }
}

// MARK: - Private logic
private extension LocationCell {
    func configureViews() {
        contentView.addSubview(titleView)
        titleView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(coordinatesView)
        coordinatesView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate(
            [
                titleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
                titleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                titleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                coordinatesView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 8),
                coordinatesView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                coordinatesView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                coordinatesView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 8),
            ]
        )
    }
}
#endif
