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
        let featureListVC = FeatureListViewController()
        let featureNav = UINavigationController(rootViewController: featureListVC)
        featureNav.tabBarItem = UITabBarItem(
            title: "Features",
            image: UIImage(systemName: "chart.bar.xaxis"),
            tag: 1
        )

        let galleryVC = GalleryViewController()
        let galleryNav = UINavigationController(rootViewController: galleryVC)
        galleryNav.tabBarItem = UITabBarItem(
            title: "Gallery",
            image: UIImage(systemName: "photo.on.rectangle.angled"),
            tag: 0
        )

        let placeholderVC3 = UIViewController()
        placeholderVC3.view.backgroundColor = .systemGroupedBackground
        let nav3 = UINavigationController(rootViewController: placeholderVC3)
        placeholderVC3.title = "Settings"
        nav3.tabBarItem = UITabBarItem(
            title: "Settings",
            image: UIImage(systemName: "gearshape.2"),
            tag: 2
        )

        // Inject modules пачкой inside the active systemic view controller array boundaries
        self.viewControllers = [featureNav, galleryNav, nav3]
    }
}
