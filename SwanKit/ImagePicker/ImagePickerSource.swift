//
//  ImagePickerSource.swift
//  SwanKit
//
//  Created by Stanislav Pletnev on 2019-12-03.
//  Copyright © 2019 Anobisoft. All rights reserved.
//

import UIKit

public extension ImagePicker {
    
    struct SourceOptions: OptionSet {
        public let rawValue: Int
        
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
        
        public static let camera           = SourceOptions(rawValue: 1 << UIImagePickerController.SourceType.camera.rawValue)
        public static let photoLibrary     = SourceOptions(rawValue: 1 << UIImagePickerController.SourceType.photoLibrary.rawValue)
        public static let savedPhotosAlbum = SourceOptions(rawValue: 1 << UIImagePickerController.SourceType.savedPhotosAlbum.rawValue)
        
        public static let standard: SourceOptions = [.camera, .photoLibrary]
        public static let all: SourceOptions = [.camera, .photoLibrary, savedPhotosAlbum]
    }
}

//MARK: - Internal

extension UIImagePickerController.SourceType {
    var isAvailable: Bool {
        UIImagePickerController.isSourceTypeAvailable(self)
    }
}

extension ImagePicker.SourceOptions {
    func includes(_ sourceType: UIImagePickerController.SourceType) -> Bool {
        contains(Self(rawValue: 1 << sourceType.rawValue))
    }
}
