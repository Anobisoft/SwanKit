//
//  FeatureListViewController.swift
//  SwanKitDemo
//
//  Created by Stanislav Pletnev on 2026-07-19.
//  Copyright © 2026 Anobisoft. Licensed under the MIT License.
//

import UIKit
import SwanKit

// MARK: - Core Feature Ledger Model

/// A structural blueprint defining corporate metadata for runtime framework capability showcases.
@MainActor
struct FeatureItem {
    let title: String
    let description: String

    /// A factory closure invoked on the MainActor to dynamically generate target showcase view controllers.
    let targetControllerFactory: @MainActor () -> UIViewController
}

// MARK: - Feature List Dashboard Controller

/// A MainActor-isolated capability showcase dashboard indexing core subsystems features inside an interactive catalog.
@MainActor
public final class FeatureListViewController: UIViewController {

    // MARK: - Core UI Nodes

    private let tableView = UITableView(frame: .zero, style: .insetGrouped).autolayout()

    // MARK: - Data Source Ledger

    /// A structured ledger hosting active framework capability presentation blueprints.
    private var dataSource: [FeatureItem] = []

    // MARK: - Controller Lifecycle

    override public func viewDidLoad() {
        super.viewDidLoad()
        setupCanvas()
        generateFeatureRegistry()
        setupTableView()
    }

    // MARK: - Architectural Setup

    private func setupCanvas() {
        title = "SwanKit Subsystems"
        view.backgroundColor = .systemGroupedBackground
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "FeatureCell")

        // Optimize row height calculations for descriptive subheadings
        tableView.estimatedRowHeight = 70
        tableView.rowHeight = UITableView.automaticDimension

        view.addSubview(tableView)

        // Full screen safe boundary layout anchors constraints mapping
        [
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ].activate()
    }

    // MARK: - Feature Registry Compilation

    /// Bakes the active showcases matrix. This acts as our modular registration hub.
    private func generateFeatureRegistry() {
        dataSource = [
            FeatureItem(
                title: "Global Content Padding Engine",
                description: "Unified master contentInsets JIT-swizzling layer delivering safe spacing uniforms directly through UIAppearance.",
                targetControllerFactory: {
                    return PaddingShowcaseViewController()
                }
            ),
            FeatureItem(
                title: "Twin-Layer Adaptive Shadows",
                description: "Dedicated independent CoreAnimation shadow layout layers resolving clipsToBounds masking conflicts flawlessly.",
                targetControllerFactory: {
                    return ShadowShowcaseViewController()
                }
            ),
            FeatureItem(
                title: "Declarative Alert Subsystem",
                description: "Swift 6 Strict Concurrency aligned extensions for localized cancel bindings and chaining modal builders.",
                targetControllerFactory: {
                    return AlertShowcaseViewController()
                }
            )
        ]
    }
}

// MARK: - UITableViewDataSource Realization Block

extension FeatureListViewController: UITableViewDataSource {

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeatureCell", for: indexPath)
        let item = dataSource[indexPath.row]

        // Leveraging modern UIListContentConfiguration layout structures natively available from iOS 14+
        var config = UIListContentConfiguration.subtitleCell()

        config.text = item.title
        config.textProperties.font = .systemFont(ofSize: 16, weight: .semibold)
        config.textProperties.color = .label

        config.secondaryText = item.description
        config.secondaryTextProperties.font = .systemFont(ofSize: 12, weight: .regular)
        config.secondaryTextProperties.color = .secondaryLabel

        cell.contentConfiguration = config
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}

// MARK: - UITableViewDelegate Navigation Routing Pipes

extension FeatureListViewController: UITableViewDelegate {

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard indexPath.row < dataSource.count else { return }

        let selectedItem = dataSource[indexPath.row]

        // Invoke the MainActor factory closure dynamically to resolve the target controller instance
        let showcaseVC = selectedItem.targetControllerFactory()
        showcaseVC.navigationItem.largeTitleDisplayMode = .never

        // Execute smooth enterprise stack navigation transition
        self.navigationController?.pushViewController(showcaseVC, animated: true)
    }
}
