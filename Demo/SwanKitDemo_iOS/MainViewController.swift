//
//  MainViewController.swift
//  SwanKitDemo
//
//  Created by Stanislav Pletnev on 2026-07-16.
//  Copyright © 2026 Anobisoft. Licensed under the MIT License.
//

import UIKit
import SwanKit

/// A MainActor-isolated core tab container orchestrating modular workspaces
/// and injecting fluid cinematic slide animations via SwanKit's TabBarDelegate mechanics.
@MainActor
final class MainViewController: TabBarController {

    // MARK: - Controller Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupTabsHierarchy()
    }

    // MARK: - Setup Configuration Pipelines

    private func setupNavigation() {
        title = "SwanKit Workspace"
    }

    private func setupTabsHierarchy() {
        // Tab 1: Our newly refactored photo selection and caching dashboard controller
        let galleryVC = GalleryViewController()
        let galleryNav = UINavigationController(rootViewController: galleryVC)
        galleryNav.tabBarItem = UITabBarItem(
            title: "Gallery",
            image: UIImage(systemName: "photo.on.rectangle.angled"),
            tag: 0
        )

        // Tab 2: Placeholder shell for future subsystems visualization
        let metricsVC = MetricsViewController()
        let nav2 = UINavigationController(rootViewController: metricsVC)
        nav2.tabBarItem = UITabBarItem(title: "Metrics", image: UIImage(systemName: "chart.bar.xaxis"), tag: 1)

        // Tab 3: Placeholder shell for future subsystems visualization
        let placeholderVC3 = UIViewController()
        placeholderVC3.view.backgroundColor = .systemGroupedBackground
        let nav3 = UINavigationController(rootViewController: placeholderVC3)
        placeholderVC3.title = "System Settings"
        nav3.tabBarItem = UITabBarItem(
            title: "Settings",
            image: UIImage(systemName: "gearshape.2"),
            tag: 2
        )

        // Inject modules пачкой inside the active systemic view controller array boundaries
        self.viewControllers = [galleryNav, nav2, nav3]
    }
}
