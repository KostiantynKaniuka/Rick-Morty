//
//  LoadingView\.swift
//  Rick&Morty
//
//  Created by Kostiantyn Kaniuka on 17.05.2024.
//

import UIKit

final class LoadingView: UIView {
    enum BackgroundStyle {
        case solid
        case semiTransparent
        case clear

        var color: UIColor? {
            switch self {
            case .solid: return .darkGray
            case .semiTransparent: return .darkGray.withAlphaComponent(0.75)
            case .clear: return nil
            }
        }
    }

    private let backgroundStyle: BackgroundStyle
    private let activityIndicator = UIActivityIndicatorView(style: .large)

    init(backgroundStyle: BackgroundStyle = .solid) {
        self.backgroundStyle = backgroundStyle

        super.init(frame: .zero)

        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setActivityIndicator(hidden: Bool) {
        activityIndicator.isHidden = hidden
        hidden ? activityIndicator.stopAnimating() : activityIndicator.startAnimating()
    }

    private func setup() {
        backgroundColor = backgroundStyle.color
        setupActivityIndicator()
    }

    private func setupActivityIndicator() {
        activityIndicator.color = .systemBackground
        activityIndicator.startAnimating()

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }
}
