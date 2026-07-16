//
//  TabBarSlideTransitionController.swift
//  SwanKit
//
//  Created by Stanislav Pletnev on 2026-07-16.
//  Copyright © 2026 Anobisoft. Licensed under the MIT License.
//

import UIKit

/// A declarative registry containing pre-configured, MainActor-isolated `UITabBarControllerDelegate` presentation behaviors.
@MainActor
public struct TabBarDelegate {

    /// A slide transition where the outgoing view controller is removed smoothly to the margins, revealing the incoming view.
    public static let removeSlideTransition: UITabBarControllerDelegate =
    TabBarTransitionControllerDelegate(slide: .init(.removeToRight), .init(.removeToLeft))

    /// A bidirectional cinematic slide transition where view controllers slide parallel to each other simulating page navigation.
    public static let moveSlideTransition: UITabBarControllerDelegate =
    TabBarTransitionControllerDelegate(slide: .init(.fromLeftToRight), .init(.fromRightToLeft))

    /// A stacking slide transition where the incoming view controller slides on top of the current layout boundary.
    public static let coverSlideTransition: UITabBarControllerDelegate =
    TabBarTransitionControllerDelegate(slide: .init(.coverFromLeft), .init(.coverFromRight))
}

@MainActor
public extension TabBarTransitionControllerDelegate {

    /// Convenience initializer to synthesize a tab bar animator using clean directional parameters.
    /// - Parameters:
    ///   - toPrev: The transition applied when navigating backward (to an index lower than the active index).
    ///   - toNext: The transition applied when navigating forward (to an index higher than the active index).
    convenience init(slide toPrev: TabBarSlideTransitioning, _ toNext: TabBarSlideTransitioning) {
        self.init(toPrev: toPrev, toNext: toNext)
    }
}

/// A MainActor-isolated coordinator acting as a `UITabBarControllerDelegate` to intercept and dynamically inject targeted transition animators.
@MainActor
public class TabBarTransitionControllerDelegate: NSObject {

    private let toNext: UIViewControllerAnimatedTransitioning
    private let toPrev: UIViewControllerAnimatedTransitioning

    /// Initializes a tab bar animation coordinator context.
    /// - Parameters:
    ///   - toPrev: Animator bound to leftward backward strides.
    ///   - toNext: Animator bound to rightward forward strides.
    public init(toPrev: UIViewControllerAnimatedTransitioning, toNext: UIViewControllerAnimatedTransitioning) {
        self.toPrev = toPrev
        self.toNext = toNext
    }
}

// MARK: - UITabBarControllerDelegate Conformance

extension TabBarTransitionControllerDelegate: UITabBarControllerDelegate {

    public func tabBarController(
        _ tabBarController: UITabBarController,
        animationControllerForTransitionFrom fromVC: UIViewController,
        to toVC: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {

        guard
            let viewControllers = tabBarController.viewControllers, viewControllers.count >= 2,
            let fromIndex = viewControllers.firstIndex(of: fromVC),
            let toIndex = viewControllers.firstIndex(of: toVC)
        else { return nil }

        return toIndex > fromIndex ? toNext : toPrev
    }
}

/// A highly customizable, MainActor-isolated slide transitions animator implementation executing transactional view controller frame mutations.
@MainActor
public class TabBarSlideTransitioning: NSObject {

    /// The structural motion behaviors supported by the animator instance.
    public enum Style {
        case removeToLeft
        case removeToRight
        case fromRightToLeft
        case fromLeftToRight
        case coverFromLeft
        case coverFromRight
    }

    private let style: Style

    /// The geometric baseline time duration of the view layout keyframe interpolation sequence. Defaults to 0.35s.
    public var duration: TimeInterval

    /// Instantiates a specialized viewport slide transition configuration layout profile.
    /// - Parameters:
    ///   - style: The visual frame manipulation motion style case rule.
    ///   - duration: The duration metrics context window. Defaults to 0.35.
    public required init(_ style: Style, duration: TimeInterval = 0.35) {
        self.style = style
        self.duration = duration
    }
}

// MARK: - UIViewControllerAnimatedTransitioning Conformance

extension TabBarSlideTransitioning: UIViewControllerAnimatedTransitioning {

    public func transitionDuration(
        using transitionContext: UIViewControllerContextTransitioning?
    ) -> TimeInterval {
        return duration
    }

    public func animateTransition(
        using transitionContext: UIViewControllerContextTransitioning
    ) {
        guard
            let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to)
        else {
            transitionContext.completeTransition(false)
            return
        }

        let targetFrame = transitionContext.initialFrame(for: fromVC)
        var lFrame = targetFrame
        lFrame.origin.x -= targetFrame.width
        var rFrame = targetFrame
        rFrame.origin.x += targetFrame.width

        switch style {
        case .removeToLeft, .removeToRight:
            toVC.view.frame = targetFrame
        case .fromRightToLeft, .coverFromRight:
            toVC.view.frame = rFrame
        case .fromLeftToRight, .coverFromLeft:
            toVC.view.frame = lFrame
        }

        switch style {
        case .coverFromRight, .coverFromLeft:
            transitionContext.containerView.addSubview(toVC.view)
        default:
            transitionContext.containerView.insertSubview(toVC.view, at: 0)
        }

        let animations = {
            switch self.style {
            case .removeToLeft:
                fromVC.view.frame = lFrame
            case .removeToRight:
                fromVC.view.frame = rFrame
            case .fromRightToLeft:
                fromVC.view.frame = lFrame
                toVC.view.frame = targetFrame
            case .fromLeftToRight:
                fromVC.view.frame = rFrame
                toVC.view.frame = targetFrame
            case .coverFromLeft, .coverFromRight:
                toVC.view.frame = targetFrame
            }
        }

        UIView.animate(withDuration: duration, animations: animations) { success in
            fromVC.view.removeFromSuperview()
            transitionContext.completeTransition(success)
        }
    }
}
