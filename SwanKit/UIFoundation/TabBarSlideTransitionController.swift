//
//  TabBarSlideTransition.swift
//  SwanKit
//
//  Created by Stanislav Pletnev on 2019-25-11.
//  Copyright © 2019 Anobisoft. All rights reserved.
//

import UIKit

public struct TabBarDelegate {
    public static let removeSlideTransition: UITabBarControllerDelegate =
        TabBarTransitionControllerDelegate(slide: .init(.removeToRight), .init(.removeToLeft))
    public static let moveSlideTransition: UITabBarControllerDelegate =
        TabBarTransitionControllerDelegate(slide: .init(.fromLeftToRight), .init(.fromRightToLeft))
    public static let coverSlideTransition: UITabBarControllerDelegate =
        TabBarTransitionControllerDelegate(slide: .init(.coverFromLeft), .init(.coverFromRight))
}

public extension TabBarTransitionControllerDelegate  {
    convenience init(slide toPrev: TabBarSlideTransitioning, _ toNext: TabBarSlideTransitioning) {
        self.init(toPrev: toPrev, toNext: toNext)
    }
}

public class TabBarTransitionControllerDelegate: NSObject, UITabBarControllerDelegate  {

    private let toNext: UIViewControllerAnimatedTransitioning
    private let toPrev: UIViewControllerAnimatedTransitioning

    public init(toPrev: UIViewControllerAnimatedTransitioning, toNext: UIViewControllerAnimatedTransitioning) {
        self.toPrev = toPrev
        self.toNext = toNext
    }
    
    public func tabBarController(_ tabBarController: UITabBarController,
                          animationControllerForTransitionFrom fromVC: UIViewController,
                          to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        guard
            let viewControllers = tabBarController.viewControllers, viewControllers.count >= 2,
            let fromIndex = viewControllers.firstIndex(of: fromVC),
            let toIndex = viewControllers.firstIndex(of: toVC)
        else { return nil }
        
        return toIndex > fromIndex ? toNext : toPrev
    }
}

public class TabBarSlideTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    
    public required init(_ style: Style, duration: TimeInterval = 0.35) {
        self.style = style
        self.duration = duration
    }
    
    public enum Style {
        case removeToLeft
        case removeToRight
        case fromRightToLeft
        case fromLeftToRight
        case coverFromLeft
        case coverFromRight
    }
    
    private let style: Style
    public var duration: TimeInterval
    
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
