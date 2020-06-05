//
//  ImagePicker.swift
//  SwanKit
//
//  Created by Stanislav Pletnev on 2019-10-30.
//  Copyright © 2019 Anobisoft. All rights reserved.
//

import UIKit

public extension UIViewController {
    func show(_ imagePicker: ImagePicker, handler: @escaping ImagePicker.Handler) {
        imagePicker.show(on: self, handler: handler)
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
    
    public typealias Handler = (_ image: UIImage?) -> Void
    
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
    
    var delegate: Delegate?
    var availableSources = [UIImagePickerController.SourceType]()
    weak var presenter: UIViewController?
    var _cancelButtonTitle: String?
    var _sourceTypesLocalizationMap: [UIImagePickerController.SourceType: String] = [:]
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
