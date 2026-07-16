//
//  RootContainer.swift
//  SwanKit
//
//  Created by Stanislav Pletnev on 2026-07-16.
//  Copyright © 2026 Anobisoft. Licensed under the MIT License.
//

import UIKit

/// Specific routing error flags thrown during custom view containment context swaps.
public enum NavigationError: Error {

    /// Indicates that the target user interface window scene could not be dynamically resolved or is missing.
    case sceneNotFound

    /// Indicates that the window layer hierarchy does not capture a valid ``RootContainer`` instance at its core base.
    case rootViewControllerNotFound
}

@MainActor
public extension RootContainer {

    /// A configuration structure defining keyframe options and duration parameters for root view controller substitution animations.
    struct AnimationConfig: Sendable {
        public var animationOptions: UIView.AnimationOptions
        public var animationDuration: CGFloat

        /// Standard default animation scheme executing a 0.3s camera-style transition flip from the top border.
        @MainActor
        public static let `default` = AnimationConfig(
            animationOptions: .transitionFlipFromTop,
            animationDuration: 0.3
        )
    }

    /// Safely hot-swaps the underlying root view controller inside a specific target scene container framework.
    ///
    /// This method serves as the centralized, bulletproof programmatic navigation router across SwanKit modules.
    /// It automatically locates the appropriate containment layer context, isolating transitions seamlessly on a per-window basis.
    ///
    /// ### Example Usage:
    /// ```swift
    /// try RootContainer.set(root: MainTabBarController(), with: .default)
    /// ```
    ///
    /// - Parameters:
    ///   - root: The new target `UIViewController` instance blueprint layer to inject.
    ///   - animation: The structural execution metrics and duration parameters applied to the transition. Defaults to `.default`.
    ///   - scene: An optional targeted explicit `UIScene` window container context track.
    ///            Defaults to `nil`, which automatically falls back onto `UIWindowScene.active`.
    /// - Throws: A ``NavigationError`` operation state failure flag if the scene configuration layout cannot be established cleanly.
    static func set(root: UIViewController, with animation: AnimationConfig = .default, to scene: UIScene? = nil) throws {
        guard let windowScene = scene as? UIWindowScene? ?? .active else {
            throw NavigationError.sceneNotFound
        }
        guard let rootContainer = findRootContainer(in: windowScene) else {
            throw NavigationError.rootViewControllerNotFound
        }

        // Dynamically update the instance configuration metrics before performing the swap
        rootContainer.config = animation
        rootContainer.root = root
    }
}

/// A MainActor-isolated core view controller container orchestrating seamless, animated application window state substitutions.
///
/// `RootContainer` manages view controller hierarchies using canonical child-parent containment mechanics,
/// preventing view memory leaks, auto-resolving dangling modal presented screens, and utilizing `UIView.transition`
/// pipelines to dynamically toggle primary app flow states (e.g., Auth -> Dashboard transitions).
@MainActor
public final class RootContainer: UIViewController {
    private var config: AnimationConfig = .default
    private var embedded: UIViewController?

    /// Initializes a root view container context pre-loaded with an animation scheme blueprint.
    ///
    /// - Parameters:
    ///   - config: The technical configuration settings applied onto state-swap transitions. Defaults to `.default`.
    ///   - embedded: An optional initial view controller context to load immediately. Defaults to `nil`.
    public init(config: AnimationConfig = .default, embedded: UIViewController? = nil) {
        self.config = config
        super.init(nibName: nil, bundle: nil)
        root = embedded
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Instance-level window builder bootstrapping an isolated application `UIWindow` frame bound natively onto this specific container instance.
    ///
    /// ### Example Usage:
    /// ```swift
    /// func scene(_ scene: UIScene, willConnectTo session: UISceneSession...) {
    ///     guard let windowScene = (scene as? UIWindowScene) else { return }
    ///     let container = RootContainer(config: .default, embedded: SplashViewController())
    ///     self.window = container.makeKeyAndVisibleWindow(windowScene: windowScene, session: session)
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - windowScene: The current active core `UIWindowScene` configuration profile context.
    ///   - session: The systemic active `UISceneSession` tracking metadata container.
    /// - Returns: A fully configured and layout-ready `UIWindow` instance capturing this instance as its root.
    public func makeKeyAndVisibleWindow(
        windowScene: UIWindowScene,
        session: UISceneSession
    ) -> UIWindow {
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = self
        window.makeKeyAndVisible()
        return window
    }

    /// The active embedded child view controller currently in display.
    ///
    /// Setting this property automatically evaluates transition requirements: initiates clean embedding for first-time allocations,
    /// triggers animated hot-swapping transactions if another root is present, or tears down the subview tree if `nil` is assigned.
    public var root: UIViewController? {
        get { embedded }
        set {
            guard let newValue, newValue != self else {
                removeEmbedded()
                return
            }
            guard embedded != nil else {
                embed(newValue)
                return
            }
            replaceEmbedded(with: newValue)
        }
    }

    // MARK: - Lifecycle Overrides

    public override func viewDidLoad() {
        super.viewDidLoad()
        guard let embedded, embedded.view.superview == nil else { return }
        view.addSubview(embedded.view)
        embedded.didMove(toParent: self)
    }
}

// MARK: - Private Technical Flow Implementations

@MainActor
private extension RootContainer {

    static func findRootContainer(in scene: UIWindowScene) -> RootContainer? {
        let window = scene.windows.first { window in window.rootViewController is RootContainer }
        return window?.rootViewController as? RootContainer
    }

    func embed(_ vc: UIViewController) {
        vc.willMove(toParent: self)
        if vc.parent != nil {
            if vc.view.superview != nil {
                vc.view.removeFromSuperview()
            }
            vc.removeFromParent()
        }
        embedded = vc
        addChild(vc)
        if let view = viewIfLoaded {
            view.addSubview(vc.view)
            vc.didMove(toParent: self)
        }
    }

    func removeEmbedded() {
        guard let embedded else { return }
        if embedded.presentedViewController != nil {
            embedded.dismiss(animated: true, completion: nil)
        }
        embedded.remove()
        self.embedded = nil
    }

    func replaceEmbedded(with newRoot: UIViewController) {
        guard let embedded, embedded != newRoot else { return }

        // Automatically clean up dangling modally presented view stacks to bypass window lifecycle asset crashes
        if embedded.presentedViewController != nil {
            embedded.dismiss(animated: true, completion: nil)
        }

        UIView.transition(
            from: embedded.view,
            to: newRoot.view,
            duration: config.animationDuration,
            options: config.animationOptions,
            completion: nil
        )

        embedded.remove()
        embed(newRoot)
    }
}

// MARK: - Private Subview Management Extension Utility

@MainActor
private extension UIViewController {

    func remove() {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}
