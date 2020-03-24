//
//  RootViewController.swift
//  SwanKit
//
//  Created by Stanislav Pletnev on 2019-25-11.
//  Copyright © 2019 Anobisoft. All rights reserved.
//

import UIKit

public extension UIApplication {
    static var rootViewController: UIViewController? {
        get { RootViewController.shared.current }
        set { RootViewController.shared.current = newValue }
    }
    
    var rootViewController: UIViewController? {
        get { RootViewController.shared.current }
        set { RootViewController.shared.current = newValue }
    }
}


final class RootViewController: UIViewController {
    
    public var animationOptions: UIView.AnimationOptions = .transitionFlipFromTop
    
    public init(_ animationOptions: UIView.AnimationOptions) {
        self.animationOptions = animationOptions
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.current = Self.instance.embedded
        Self.instance = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if let embedded = embedded, embedded.view.superview == nil {
            view.addSubview(embedded.view)
            embedded.didMove(toParent: self)
        }
    }
    
    static var instance = RootViewController(.transitionFlipFromTop)


    
    public static var shared: RootViewController {
        return makeRoot()
    }

    @discardableResult
    private static func makeRoot() -> RootViewController {
        guard let window = UIWindow.key else {
            NotificationCenter.default.addObserver(forName: UIWindow.didBecomeKeyNotification, object: nil, queue: .main) { _ in
                makeRoot()
            }
            return instance
        }
        if let root = window.rootViewController as? RootViewController {
            return root
        } else {
            let root = instance
            window.rootViewController = root
            return root
        }
    }
    
    public var current: UIViewController? {
        set {
            guard let newValue = newValue, newValue != self else {
                if let embedded = embedded {
                    if embedded.presentedViewController != nil {
                        embedded.dismiss(animated: true, completion: nil)
                    }
                    embedded.remove()
                    self.embedded = nil
                }
                return
            }
            guard let embedded = embedded else {
                self.embed(newValue)
                return
            }
            if embedded != newValue {
                UIView.transition(from: embedded.view, to: newValue.view, duration: 0.3, options: [ animationOptions ], completion: nil)
                if embedded.presentedViewController != nil {
                    embedded.dismiss(animated: true, completion: nil)
                }
                embedded.remove()
                embed(newValue)
            }
        }
        get {
            embedded
        }
    }

    private var embedded: UIViewController?

    private func embed(_ vc: UIViewController) {
        if vc.parent != nil {
            willMove(toParent: self)
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

}

private extension UIViewController {
    func remove() {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}
