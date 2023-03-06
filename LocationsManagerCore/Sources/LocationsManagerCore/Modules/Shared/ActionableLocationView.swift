//
//  ActionableLocationView.swift
//  
//
//  Created by Sergey Petrachkov on 06.03.2023.
//

#if canImport(UIKit)
import UIKit

final class ActionableLocationView: UIView {

    private lazy var contentView = LocationView(frame: .zero)

    private lazy var accessoryView: UIImageView = {
        let view = UIImageView(image: UIImage(systemName: "chevron.right"))
        view.contentMode = .scaleAspectFit
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSubviews()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(title: String, subtitle: String) {
        contentView.configure(title: title, subtitle: subtitle)
    }
}

private extension ActionableLocationView {

    func configureSubviews() {
        backgroundColor = .systemBackground
        addSubview(contentView)
        addSubview(accessoryView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        accessoryView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                accessoryView.heightAnchor.constraint(equalToConstant: 16),
                accessoryView.widthAnchor.constraint(equalToConstant: 16),
                accessoryView.centerYAnchor.constraint(equalTo: centerYAnchor),
                accessoryView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

                contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
                contentView.topAnchor.constraint(equalTo: topAnchor),
                contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
                contentView.trailingAnchor.constraint(equalTo: accessoryView.leadingAnchor, constant: 8),
            ]
        )
    }
}
#endif
