
import UIKit

extension UIImage {
    // TODO: make it safe
    nonisolated(unsafe) private static let pixelCache = Cache<UIColor, UIImage>()

    static func pixel(_ color: UIColor) async -> UIImage {
        if let cached = pixelCache[color] {
            return cached
        }

        let size = CGSize(width: 1.0, height: 1.0)
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(size, true, await UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()!

        context.setFillColor(color.cgColor)
        context.fill(rect)

        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        pixelCache[color] = image
        return image
    }
}

