//
//  SceneDelegate.swift
//  SwanKitDemo
//
//  Created by Stanislav Pletnev on 2026-07-16.
//  Copyright © 2026 Anobisoft. Licensed under the MIT License.
//

import UIKit
import SwanKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }

        // Feature Used: AppearanceConfigurator layout dispatch
        // Note: Global UIAppearance properties (such as swizzled text fields padding and cascading bar stylings)
        // are hooked and registered uniformly on application subsystem boot.
        AppearanceConfigurator.configureGlobalAppearance()

        // Feature Used: MainViewController lazy view orchestration architecture
        // Dedicated view controllers instantiated safely on the execution boundary.
        let viewController = MainViewController()
        let navigationController = UINavigationController(rootViewController: viewController)

        // Feature Used: RootContainer architecture mapping windows metrics management context
        // SwanKit's centralized window factory node handling native scene connections.
        let rootContainer = RootContainer(embedded: navigationController)

        // Feature Used: RootContainer.makeKeyAndVisibleWindow factory dispatch routing
        // Automatically instantiates a styled UIWindow blueprint conforming directly to standard session setups.
        window = rootContainer.makeKeyAndVisibleWindow(windowScene: windowScene, session: session)
    }
}
