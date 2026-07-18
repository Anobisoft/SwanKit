//
//  AppearanceConfigurator.swift
//  SwanKitDemo
//
//  Created by Stanislav Pletnev on 2026-07-16.
//  Copyright © 2026 Anobisoft. Licensed under the MIT License.
//

import UIKit
import SwanKit

/// A MainActor-isolated configuration manager that styles systemic UI components globally
/// via declarative SwanKit ViewChainingAppearance pipelines on application launch.
@MainActor
public final class AppearanceConfigurator {

    private init() {}

    /// Dispatches and bakes the global UIAppearance token overrides on the application launch context boundary.
    public static func configureGlobalAppearance() {

        // 1. Global Navigation Bar Styling (Pure SwanKit Chaining Matrix)
        UINavigationBar.appearance { proxy in
            proxy
                .tintColor(.systemBlue)
                .barTintColor(.systemBackground)
                .standardAppearance { appearance in
                    appearance
                        .backgroundColor(.systemBackground)
                        .titleTextAttributes([
                            .foregroundColor: UIColor.label,
                            .font: UIFont.systemFont(ofSize: 17, weight: .semibold)
                        ])
                        .largeTitleTextAttributes([
                            .foregroundColor: UIColor.label,
                            .font: UIFont.systemFont(ofSize: 34, weight: .bold)
                        ])
                }
                .scrollEdgeAppearance(copy: .standard)
                .compactAppearance(copy: .standard)
        }

        // 2. Global Tab Bar Styling (Pure SwanKit Chaining & Control)
        UITabBar.appearance { proxy in
            proxy
                .tintColor(.systemBlue)
                .unselectedItemTintColor(.secondaryLabel)
                .standardAppearance { appearance in
                    appearance
                        .backgroundColor(.systemBackground)
                        .inlineItemAppearance { item in
                            item.normal.titleTextAttributes = [.foregroundColor: UIColor.secondaryLabel]
                            item.selected.titleTextAttributes = [.foregroundColor: UIColor.systemBlue]
                        }
                        .copyToCompact() // Контролируемо дублируем настройки на ландшафтную ориентацию
                }
                .scrollEdgeAppearance(copy: .standard)
        }

        // 3. Global Modern Button Styling (iOS 16+ Chaining Integration)
        UIButton.appearance().configurationUpdateHandler = { button in
            var config = button.configuration ?? UIButton.Configuration.filled()
            config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
                var outgoing = incoming
                outgoing.font = UIFont.systemFont(ofSize: 16, weight: .medium)
                return outgoing
            }
            button.configuration = config
        }

        // 4. Global Controlled Text Field Layout & Design System Integration
        // Полный каскад отступов (свизлинг) и параметров границ (UIView+Layer)
        UITextField.appearance { proxy in
            proxy
                .edgeInsets(UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16))
                .backgroundColor(.systemBackground)
                .cornerRadius(8)
                .borderWidth(1)
                .borderColor(.systemGray4)
        }

        // 5. Global Switches Styling (Chaining DSL)
        UISwitch.appearance { proxy in
            proxy
                .onTintColor(.systemBlue.withAlphaComponent(0.8))
                .thumbTintColor(.white)
        }

        // 6. Global Activity Indicators Styling (Chaining DSL)
        UIActivityIndicatorView.appearance { proxy in
            proxy
                .color(.systemBlue)
                .hidesWhenStopped(true)
        }
    }
}
