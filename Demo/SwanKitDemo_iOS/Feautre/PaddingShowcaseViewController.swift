//
//  PaddingShowcaseViewController.swift
//  SwanKitDemo
//
//  Created by Stanislav Pletnev on 2026-07-19.
//  Copyright © 2026 Anobisoft. Licensed under the MIT License.
//

import UIKit
import SwanKit

/// A MainActor-isolated capability showcase demonstrating premium typography
/// bounds formatting and interactive inline source code annotations enclosed inside a scrollable viewport.
@MainActor
final class PaddingShowcaseViewController: UIViewController {

    // MARK: - Core Scrolling Container Nodes

    private let scrollView = UIScrollView().autolayout()

    // MARK: - FEATURE 1: Square UIImageView Badge & Its Annotation

    private let badgeImageView = UIImageView()
        .image(UIImage(systemName: "star.fill")?
            .withTintColor(.systemIndigo, renderingMode: .alwaysOriginal)
            .withSolidBackground(color: .white, canvasSize: CGSize(width: 24, height: 24)))
        .backgroundColor(.systemIndigo)
        .contentMode(.center) // Keeps our custom 24x24 asset crisp without stretching
        .clipsToBounds(true)
        .contentInsets(all: 16)

    private let badgeCodeLabel = StatusConsoleLabel().autolayout()
        .text("""
        let badgeImageView = UIImageView()
            .image(UIImage(systemName: "star.fill")?
                .withTintColor(.systemBlue, renderingMode: .alwaysOriginal)
                .withBackground(color: .white))
            .backgroundColor(.systemIndigo)
            .clipsToBounds(true)
            .contentInsets(all: 20)
        """)

    private lazy var badgeSectionStack = UIStackView().autolayout()
        .arrangedSubviews([badgeImageView, badgeCodeLabel])
        .axis(.vertical)
        .spacing(12)
        .alignment(.center)

    // MARK: - FEATURE 2: Pill Track & Its Annotation

    private let pillLabel = UILabel()
        .text("SWANKIT CORE")
        .textColor(.systemBlue)
        .font(.systemFont(ofSize: 12, weight: .bold))
        .textAlignment(.center)
        .numberOfLines(1)
        .backgroundColor(UIColor.systemBlue.withAlphaComponent(0.15))
        .cornerRadius(14)
        .clipsToBounds(true)
        .contentInsets(top: 8, left: 24, bottom: 8, right: 24)

    private let pillCodeLabel = StatusConsoleLabel().autolayout()
        .text("""
        let pillLabel = UILabel()
            .text("SWANKIT CORE")
            .textColor(.systemBlue)
            .font(.systemFont(ofSize: 12, weight: .bold))
            .textAlignment(.center)
            .numberOfLines(1)
            .backgroundColor(.systemBlue.withAlphaComponent(0.15))
            .cornerRadius(14)
            .clipsToBounds(true)
            .contentInsets(top: 8, left: 24, bottom: 8, right: 24)
        """)

    private lazy var pillSectionStack = UIStackView().autolayout()
        .arrangedSubviews([pillLabel, pillCodeLabel])
        .axis(.vertical)
        .spacing(12)
        .alignment(.center)

    // MARK: - FEATURE 3: Rounded Banner & Its Annotation

    private let bannerLabel = UILabel()
        .text("Subsystem Integrity: Fully Operational")
        .textColor(.label)
        .font(.systemFont(ofSize: 14, weight: .medium))
        .textAlignment(.center)
        .numberOfLines(1)
        .backgroundColor(.secondarySystemGroupedBackground)
        .cornerRadius(12)
        .clipsToBounds(true)
        .contentInsets(horizontal: 16, vertical: 16)

    private let bannerCodeLabel = StatusConsoleLabel().autolayout()
        .text("""
        let bannerLabel = UILabel()
            .text("Subsystem Integrity: Fully Operational")
            .textColor(.label)
            .font(.systemFont(ofSize: 14, weight: .medium))
            .textAlignment(.center)
            .numberOfLines(1)
            .backgroundColor(.secondarySystemGroupedBackground)
            .cornerRadius(12)
            .clipsToBounds(true)
            .contentInsets(horizontal: 16, vertical: 16)
        """)

    private lazy var bannerSectionStack = UIStackView().autolayout()
        .arrangedSubviews([bannerLabel, bannerCodeLabel])
        .axis(.vertical)
        .spacing(12)
        .alignment(.center)

    // MARK: - Master Container Stack

    private lazy var masterStack = UIStackView().autolayout()
        .arrangedSubviews([badgeSectionStack, pillSectionStack, bannerSectionStack])
        .axis(.vertical)
        .spacing(36)
        .alignment(.fill)
        .distribution(.fill)

    // MARK: - Controller Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCanvas()
        setupLayout()
        adjustAnnotationFonts()
    }

    // MARK: - Configurations Mechanics

    private func setupCanvas() {
        title = "Padding Geometry"
        view.backgroundColor = .systemGroupedBackground
    }

    private func adjustAnnotationFonts() {
        let fineFont = UIFont.monospacedSystemFont(ofSize: 9, weight: .bold)
        badgeCodeLabel.font(fineFont)
        pillCodeLabel.font(fineFont)
        bannerCodeLabel.font(fineFont)

        badgeCodeLabel.textAlignment(.left)
        pillCodeLabel.textAlignment(.left)
        bannerCodeLabel.textAlignment(.left)
    }

    private func setupLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(masterStack)

        [
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            masterStack.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 24),
            masterStack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -24),

            masterStack.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 12),
            masterStack.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -12)
        ].activate()
    }
}
