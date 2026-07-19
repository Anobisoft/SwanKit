//
//  TabBarController.swift
//  SwanKit
//
//  Created by anobisoft on 2026-07-19.
//

import UIKit

@MainActor
class TabBarController: UITabBarController {
    private let tabBarDelegate: TabBarDelegate

    init(tabBarDelegate: TabBarDelegate = .moveSlideTransition) {
        self.tabBarDelegate = tabBarDelegate
        super.init(nibName: nil, bundle: nil)
        delegate = tabBarDelegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupScreenEdgePanGestures()
    }

    private func setupScreenEdgePanGestures() {
        let leftEdgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleEdgePan(_:)))
        leftEdgeGesture.edges = .left
        view.addGestureRecognizer(leftEdgeGesture)

        let rightEdgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleEdgePan(_:)))
        rightEdgeGesture.edges = .right
        view.addGestureRecognizer(rightEdgeGesture)
    }

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

            if selectedIndex == previousIndex {
                tabBarDelegate.interactionController = nil
            }

        case .changed:
            tabBarDelegate.interactionController?.update(progress)

        case .ended:
            let translation = gesture.translation(in: view)
            let velocity = gesture.velocity(in: view).x

            let isForwardSwipe = (gesture.edges == .right && velocity < 0) || (gesture.edges == .left && velocity > 0)
            let shouldComplete = progress > 0.3 && isForwardSwipe

            if shouldComplete {
                tabBarDelegate.interactionController?.finish()
            } else {
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
