//
//  ShadowShowcaseViewController.swift
//  SwanKitDemo
//
//  Created by Stanislav Pletnev on 2026-07-19.
//  Copyright © 2026 Anobisoft. Licensed under the MIT License.
//

import UIKit
import SwanKit

/// An isolated subclass to target layout styling hooks specifically for the shadow presentation workspace.
final class ShadowShowcaseCard: UIView {}

/// A MainActor-isolated controller showcasing standard static design system layer shadows.
@MainActor
final class ShadowShowcaseViewController: UIViewController {

    // MARK: - UI Elements (Configured purely via design system chaining)

    private let plainCard = ShadowShowcaseCard()
        .backgroundColor(.systemBackground)

    private let responsiveCard = ShadowShowcaseCard()
        .backgroundColor(.systemBackground)
        .shadow(
            radius: 8,
            color: { $0.userInterfaceStyle == .dark ? .white : .black },
            opacity: 0.5,
            offset: CGSize(width: 0, height: 4)
        )

    private let neonCard = ShadowShowcaseCard()
        .backgroundColor(.systemBlue.withAlphaComponent(0.5))
        .shadow(radius: 12, color: { _ in .systemBlue }, opacity: 0.35, offset: CGSize(width: 0, height: 6))

    /// The master layout stack coordinated entirely via native SwanKit method chaining loops.
    private lazy var stack = UIStackView().autolayout()
        .arrangedSubviews([plainCard, responsiveCard, neonCard])
        .axis(.vertical)
        .spacing(32)
        .distribution(.fillEqually)

    // MARK: - Controller Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCanvas()
        setupLayout()
    }

    // MARK: - Configurations Mechanics

    private func setupCanvas() {
        title = "Adaptive Shadows"
        view.backgroundColor = .systemGroupedBackground

        // Configure general layout tokens shared uniformly across the shadow showcase ledger
        ShadowShowcaseCard.appearance {
            $0
                .cornerRadius(16)
                .clipsToBounds(true) // Triggers public _clipsToBounds routing under the chaining hood natively
        }
    }

    private func setupLayout() {
        // Embed tracking textual placeholders into target rendering containers
        addDescription(to: plainCard, text: "Card: Base Frame\n(No Shadow Layer)")
        addDescription(to: responsiveCard, text: "Card: Responsive Shadow\n(Black in Light / White in Dark)")
        addDescription(to: neonCard, text: "Card: Immersive Shadow\n(System Blue Glow)")

        view.addSubview(stack)

        [
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            stack.heightAnchor.constraint(equalToConstant: 420)
        ].activate()
    }

    /// Helper to embed a standard subtitle token inside a target presentation view block.
    private func addDescription(to container: UIView, text: String) {
        let label = UILabel().autolayout()
            .text(text)
            .textColor(container.backgroundColor?.isDark == true ? .white : .label)
            .font(.systemFont(ofSize: 14, weight: .bold))
            .numberOfLines(0)
            .textAlignment(.center)

        container.addSubview(label)

        [
            label.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16)
        ].activate()
    }
}
