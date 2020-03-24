//
//  ImagePickerLocalize.swift
//  SwanKit
//
//  Created by Stanislav Pletnev on 2019-12-03.
//  Copyright © 2019 Anobisoft. All rights reserved.
//

import Foundation

public extension ImagePicker {
    
    static var sourceTypesLocalizationMap: [UIImagePickerController.SourceType: String] {
        get {
            _sourceTypesLocalizationMap
        }
        set {
            if newValue.count == _sourceTypesLocalizationMap.count {
                _sourceTypesLocalizationMap = newValue
            }
        }
    }

    static var cancelButtonTitle: String?

    private static var _sourceTypesLocalizationMap: [UIImagePickerController.SourceType: String] = [
        .camera: "Camera".localized(.UIKit),
        .photoLibrary: "Photo Library".localized(.UIKit),
        .savedPhotosAlbum: "Saved Photos Album".localized(.UIKit),
    ]
}
