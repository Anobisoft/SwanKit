
import UIKit

public extension ImagePicker {
    private typealias SourceType = UIImagePickerController.SourceType

    struct SourceOptions: OptionSet, Sendable {
        public let rawValue: Int
        
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
        
        public static let camera           = SourceOptions(rawValue: 1 << SourceType.camera.rawValue)
        public static let photoLibrary     = SourceOptions(rawValue: 1 << SourceType.photoLibrary.rawValue)
        public static let savedPhotosAlbum = SourceOptions(rawValue: 1 << SourceType.savedPhotosAlbum.rawValue)

        public static let standard: SourceOptions = [.camera, .photoLibrary]
        public static let all: SourceOptions = [.camera, .photoLibrary, savedPhotosAlbum]
    }
}

//MARK: - Internal

extension UIImagePickerController.SourceType {
    @MainActor
    var isAvailable: Bool {
        UIImagePickerController.isSourceTypeAvailable(self)
    }
}

extension ImagePicker.SourceOptions {
    func includes(_ sourceType: UIImagePickerController.SourceType) -> Bool {
        contains(Self(rawValue: 1 << sourceType.rawValue))
    }
}
