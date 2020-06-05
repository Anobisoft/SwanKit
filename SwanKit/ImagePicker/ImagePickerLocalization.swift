//
//  ImagePickerLocalize.swift
//  SwanKit
//
//  Created by Stanislav Pletnev on 2019-12-03.
//  Copyright © 2019 Anobisoft. All rights reserved.
//

import Foundation

public extension ImagePicker {
    
    var cancelButtonTitle: String {
        get { _cancelButtonTitle ?? Self.cancelButtonTitle }
        set { _cancelButtonTitle = newValue }
    }
    
    var sourceTypesLocalizationMap: [UIImagePickerController.SourceType: String] {
        get {
            Self.sourceTypesLocalizationMap.merging(_sourceTypesLocalizationMap) { (_, new) in new }
        }
        set {
            _sourceTypesLocalizationMap.merge(newValue) { (_, new) in new }
        }
    }
    
    private static let sourceTypesLocalizationMap: [UIImagePickerController.SourceType: String] = [
        .camera: "Camera".localized(.UIKit),
        .photoLibrary: "Photo Library".localized(.UIKit),
        .savedPhotosAlbum: "Saved Photos Album".localized(.UIKit),
    ]
    
    private static let cancelButtonTitle = "Cancel".localized(.UIKit)
}
