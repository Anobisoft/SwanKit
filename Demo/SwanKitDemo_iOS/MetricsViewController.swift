//
//  MetricsViewController.swift
//  SwanKitDemo
//
//  Created by Stanislav Pletnev on 2026-07-19.
//  Copyright © 2026 Anobisoft. Licensed under the MIT License.
//

import UIKit
import SwanKit

/// An isolated laboratory test controller anchoring the PaddingLabel component execution metrics.
@MainActor
final class MetricsViewController: UIViewController {

    // MARK: - UI Elements

    private let shadowView = UIView().autolayout()

    // Ссылки на констрейнты размеров, чтобы плавно менять их в анимации
    private var widthConstraint: NSLayoutConstraint?
    private var heightConstraint: NSLayoutConstraint?

    // MARK: - Controller Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCanvas()
        setupTestLabelGeometry()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        shadowView.backgroundColor = .init(rgb: arc4random_uniform(0xFFFFFF))
    }

    // MARK: - Configurations Mechanics

    private func setupCanvas() {
        title = "Metrics Subsystem"
        view.backgroundColor = .systemGroupedBackground
    }

    private func setupTestLabelGeometry() {
//        shadowView.layer.cornerRadius = 16
        shadowView.shadow()

        view.addSubview(shadowView)

        [
            shadowView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            shadowView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            shadowView.widthAnchor.constraint(equalToConstant: 120),
            shadowView.heightAnchor.constraint(equalToConstant: 120),
        ].activate()
    }
}
