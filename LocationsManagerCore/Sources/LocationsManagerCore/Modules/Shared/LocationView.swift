//
//  LocationView.swift
//  
//
//  Created by Sergey Petrachkov on 05.03.2023.
//

#if canImport(UIKit)
import UIKit

final class LocationView: UIView {
    // MARK: - UI props
    private lazy var titleView: UILabel = {
        let view = UILabel(frame: .zero)
        view.font = .preferredFont(forTextStyle: .headline)
        view.numberOfLines = 0
        return view
    }()

    private lazy var coordinatesView: UILabel = {
        let view = UILabel(frame: .zero)
        view.font = .preferredFont(forTextStyle: .subheadline)
        view.textColor = .secondaryLabel
        view.numberOfLines = 0
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

private extension LocationView {
    func configureViews() {
        addSubview(titleView)
        titleView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(coordinatesView)
        coordinatesView.translatesAutoresizingMaskIntoConstraints = false

        self.backgroundColor = .systemBackground

        NSLayoutConstraint.activate(
            [
                titleView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
                titleView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
                titleView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
                coordinatesView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 8),
                coordinatesView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
                coordinatesView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
                coordinatesView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
            ]
        )
    }
}
#endif
