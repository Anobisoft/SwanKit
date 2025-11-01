
import UIKit

private extension RootContainer {
    static var windows: [String: UIWindow] = [:]
}

public extension RootContainer {
    @MainActor
    struct AnimationConfig {
        public var animationOptions: UIView.AnimationOptions
        public var animationDuration: CGFloat

        public static let `default` = AnimationConfig(animationOptions: .transitionFlipFromTop, animationDuration: 0.3)
    }

    static var rootViewController: UIViewController? {
        get {
            guard let activeContainer else { return nil }
            return activeContainer.root
        }
        set {
            guard let activeContainer else { return }
            activeContainer.root = newValue
        }
    }
}

public final class RootContainer: UIViewController {
    private var config: AnimationConfig = .default
    private var embedded: UIViewController?

    init(config: AnimationConfig, embedded: UIViewController? = nil) {
        self.config = config
        super.init(nibName: nil, bundle: nil)
        root = embedded
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public static func makeKeyAndVisibleWindow(
        windowScene: UIWindowScene,
        session: UISceneSession,
        animationConfig: AnimationConfig = .default
    ) -> UIWindow {
        let window = UIWindow(windowScene: windowScene)
        let container = RootContainer(config: animationConfig)

        window.rootViewController = container
        window.makeKeyAndVisible()
        Self.windows[session.configuration.name ?? "Default"] = window
        return window
    }

    public var root: UIViewController? {
        get { embedded }
        set {
            guard let newValue, newValue != self else {
                removeEmbedded()
                return
            }
            guard let embedded else {
                embed(newValue)
                return
            }
            replaceEmbedded(with: newValue)
        }
    }

    // MARK: -

    public override func viewDidLoad() {
        super.viewDidLoad()
        guard let embedded, embedded.view.superview == nil else { return }
        view.addSubview(embedded.view)
        embedded.didMove(toParent: self)
    }
}

// MARK: - Private

private extension RootContainer {
    static var activeContainer: RootContainer? {
        UIWindowScene.active?.keyWindow?.rootViewController as? RootContainer
    }

    private func embed(_ vc: UIViewController) {
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

    private func removeEmbedded() {
        guard let embedded else { return }
        if embedded.presentedViewController != nil {
            embedded.dismiss(animated: true, completion: nil)
        }
        embedded.remove()
        self.embedded = nil
    }

    private func replaceEmbedded(with newRoot: UIViewController) {
        guard let embedded, embedded != newRoot else { return }

        if embedded.presentedViewController != nil {
            embedded.dismiss(animated: true, completion: nil)
        }

        UIView.transition(from: embedded.view,
                          to: newRoot.view,
                          duration: config.animationDuration,
                          options: config.animationOptions,
                          completion: nil)

        embedded.remove()
        embed(newRoot)
    }
}

private extension UIViewController {
    func remove() {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}
