//
//  ImagePicker.swift
//  SwanKit
//
//  Created by Stanislav Pletnev on 2019-10-30.
//  Copyright © 2019 Anobisoft. All rights reserved.
//

import UIKit

public extension UIViewController {
    func show(_ imagePicker: ImagePicker, completion: @escaping ImagePicker.Completion) {
        imagePicker.show(on: self, completion: completion)
    }
}

public class ImagePicker {

    public struct AlertAction {
        public typealias Handler = (_ tag: Int) -> Void

        public var title: String?
        public var style: UIAlertAction.Style = .default
        public var handler: Handler? = nil
        public var isEnabled: Bool = true
        public var tag: Int = 0
    }
    
    public var allowsEditing: Bool = false
    
    public var cameraDevice: UIImagePickerController.CameraDevice = .rear
    public var cameraFlashMode: UIImagePickerController.CameraFlashMode = .auto
    
    public typealias Completion = (_ image: UIImage?) -> Void
    
    public convenience init?(_ sourceOptions: SourceOptions = .standard) {
        self.init(sourceOptions: sourceOptions)
    }

    public var additionalAlertActions: [AlertAction]?
    
    //MARK: - Internal
    
    init?(sourceOptions: SourceOptions) {
        for sourceType: UIImagePickerController.SourceType in [.photoLibrary, .camera, .savedPhotosAlbum] {
            if sourceOptions.includes(sourceType) && sourceType.isAvailable {
                availableSources.append(sourceType)
            }
        }
        guard availableSources.count > 0 else {
            return nil
        }
    }
    
    internal var delegate: Delegate?
    internal var availableSources = [UIImagePickerController.SourceType]()
    internal weak var presenter: UIViewController?
    
}

extension ImagePicker.AlertAction {
    public init(title: String? = nil,
                style: UIAlertAction.Style = .default,
                isEnabled: Bool = true,
                tag: Int = 0,
                handler: Handler? = nil) {

        self.title = title
        self.style = style
        self.handler = handler
        self.isEnabled = isEnabled
        self.tag = tag
    }
}
