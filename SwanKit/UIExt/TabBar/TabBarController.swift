//
//  TabBarController.swift
//  SwanKit
//
//  Created by anobisoft on 2026-07-19.
//

import UIKit

/// A MainActor-isolated, subclass of `UITabBarController` that natively injects interactive, fluid screen-edge swipe transitions.
///
/// `TabBarController` eliminates the boilerplate code required to implement bidirectional swipe navigation between tabs.
/// It monitors interactive user gestures specifically at the viewport margins using `UIScreenEdgePanGestureRecognizer`,
/// leaving the inner viewport screen real estate fully available for nesting scrolling elements like collection views or tables without conflict.
///
/// ### Architecture & Animation Integration
/// This component bridges a strong underlying reference to a ``TabBarDelegate`` (acting as the `UITabBarControllerDelegate`)
/// with a `UIPercentDrivenInteractiveTransition` pipeline. As the user slides their finger, layout frames transition
/// dynamically in real-time.
///
/// ### Fail-Safe Margin Mechanics
/// The gesture management sub-system incorporates strict index bounds validation. If a user attempts to swipe left on
/// the absolute first tab, or swipe right on the absolute final tab, the framework detects that the targeted tab index matches
/// the current index (`selectedIndex == previousIndex`) and aborts the interactive transition layout context immediately to prevent rawness or layout visual bugs.
///
/// ### Example Usage:
/// ```swift
/// @MainActor
/// final class AppWorkspaceContainer: TabBarController {
///     override func viewDidLoad() {
///         super.init(tabBarDelegate: .moveSlideTransition) // Uses default bidirectional slide
///
///         let home = UINavigationController(rootViewController: HomeViewController())
///         home.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
///
///         let profile = UINavigationController(rootViewController: ProfileViewController())
///         profile.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), tag: 1)
///
///         self.viewControllers = [home, profile]
///     }
/// }
/// ```
@MainActor
open class TabBarController: UITabBarController {

    /// The strongly retained custom animation coordinator mapping core structural delegate events.
    private let tabBarDelegate: TabBarDelegate

    /// Initializes a newly allocated tab bar container configured with specialized transition animators.
    ///
    /// - Parameter tabBarDelegate: The structural animator delegate determining the kinematic movement profile. Defaults to `.moveSlideTransition`.
    public init(tabBarDelegate: TabBarDelegate = .moveSlideTransition) {
        self.tabBarDelegate = tabBarDelegate
        super.init(nibName: nil, bundle: nil)
        self.delegate = tabBarDelegate
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle Overrides

    open override func viewDidLoad() {
        super.viewDidLoad()
        setupScreenEdgePanGestures()
    }

    // MARK: - Interactive Setup Mechanics

    /// Binds specialized screen-edge pan gesture recognizers to the left and right boundaries of the active viewport canvas.
    private func setupScreenEdgePanGestures() {
        let leftEdgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleEdgePan(_:)))
        leftEdgeGesture.edges = .left
        view.addGestureRecognizer(leftEdgeGesture)

        let rightEdgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleEdgePan(_:)))
        rightEdgeGesture.edges = .right
        view.addGestureRecognizer(rightEdgeGesture)
    }

    // MARK: - Gestures Interaction Pipeline Engine

    /// Intercepts active edge pan input events to drive the low-level interactive percentages animation framework pipelines.
    ///
    /// The animation progress tracking calculations are mapped dynamically based on the current translation width metrics:
    /// `Progress = Translation Delta X / Viewport Width Bounds`.
    ///
    /// ### Completion Criteria Matrix:
    /// Inside the `.ended` status execution scope, transaction success is evaluated mathematically. The transition finishes if:
    /// 1. The progress footprint crosses the baseline structural threshold (`progress > 0.3`).
    /// 2. The physical finger swipe speed velocity vectors match the targeted step direction (`isForwardSwipe`).
    ///
    /// - Parameter gesture: The actively dispatching system edge pan event recognizer node instance.
    @objc private func handleEdgePan(_ gesture: UIScreenEdgePanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        let progress = abs(translation.x) / view.bounds.width

        switch gesture.state {
        case .began:
            let interactionController = UIPercentDrivenInteractiveTransition()
            tabBarDelegate.interactionController = interactionController

            let previousIndex = selectedIndex

            if gesture.edges == .left {
                if selectedIndex > 0 {
                    selectedIndex -= 1
                }
            } else if gesture.edges == .right {
                if let viewControllers, selectedIndex < viewControllers.count - 1 {
                    selectedIndex += 1
                }
            }

            // Boundary validation check: If indices are identical, release the interactive proxy hooks safely
            if selectedIndex == previousIndex {
                tabBarDelegate.interactionController = nil
            }

        case .changed:
            tabBarDelegate.interactionController?.update(progress)

        case .ended:
            let velocity = gesture.velocity(in: view).x

            // Mathematical verification modeling swift swipe trajectories across left/right boundaries context maps
            let isForwardSwipe = (gesture.edges == .right && velocity < 0) || (gesture.edges == .left && velocity > 0)
            let shouldComplete = progress > 0.3 && isForwardSwipe

            if shouldComplete {
                tabBarDelegate.interactionController?.finish()
            } else {
                // Perform a clean, non-blocking hardware rollback translation
                tabBarDelegate.interactionController?.cancel()
            }

            tabBarDelegate.interactionController = nil

        case .cancelled, .failed:
            tabBarDelegate.interactionController?.cancel()
            tabBarDelegate.interactionController = nil

        case .possible:
            break

        @unknown default:
            break
        }
    }
}
