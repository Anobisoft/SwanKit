//
//  AlertShowcaseViewController.swift
//  SwanKitDemo
//
//  Created by Stanislav Pletnev on 2026-07-19.
//  Copyright © 2026 Anobisoft. Licensed under the MIT License.
//

import UIKit
import SwanKit

/// A MainActor-isolated capability showcase controller demonstrating declarative alert subsystem APIs.
@MainActor
final class AlertShowcaseViewController: UIViewController {

    // MARK: - Controller Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCanvas()
        setupControlTriggers()
    }

    // MARK: - Setup Mechanics

    private func setupCanvas() {
        title = "Alerts & Actions"
        view.backgroundColor = .systemGroupedBackground
    }

    private func setupControlTriggers() {
        // 1. Button to present standard Declarative Alert modal
        let alertButton = UIButton(configuration: .filled()).autolayout()
        alertButton.configuration?.title = "Present System Alert"
        alertButton.configuration?.baseBackgroundColor = .systemBlue
        alertButton.addAction(UIAction { [weak self] _ in self?.showDemoAlert() }, for: .touchUpInside)

        // 2. Button to present Declarative Action Sheet modal
        let sheetButton = UIButton(configuration: .filled()).autolayout()
        sheetButton.configuration?.title = "Present Action Sheet"
        sheetButton.configuration?.baseBackgroundColor = .systemIndigo
        sheetButton.addAction(UIAction { [weak self] _ in self?.showDemoActionSheet() }, for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [alertButton, sheetButton])
        stack.axis = .vertical
        stack.spacing = 16
        stack.distribution = .fill
        stack.autolayout()

        view.addSubview(stack)

        [
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ].activate()
    }

    // MARK: - Action Presenters

    private func showDemoAlert() {
        // Testing your crisp convenience initializer syntax natively!
        let alert = UIAlertController(title: "Subsystem Authentication", message: "Do you explicitly confirm deployment routing passes?")

        alert.addAction(title: "Confirm Pass", style: .default) { _ in
            print("SwanKit Status: Authentication Confirmed.")
        }

        alert.addCancel { _ in
            print("SwanKit Status: Authentication Aborted via Localized Cancel.")
        }

        self.present(alert, animated: true)
    }

    private func showDemoActionSheet() {
        let sheet = UIAlertController(title: "Destructive Action Bridge", message: "Target metrics ledger will be permanently purged.", style: .actionSheet)

        sheet.addAction(title: "Purge Database", style: .destructive) { _ in
            print("SwanKit Status: Critical Metrics Data Cleared.")
        }

        sheet.addCancel()

        self.present(sheet, animated: true)
    }
}
