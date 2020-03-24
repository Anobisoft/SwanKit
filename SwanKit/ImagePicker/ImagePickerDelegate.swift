//
//  ImagePickerDelegate.swift
//  SwanKit
//
//  Created by Stanislav Pletnev on 2019-12-03.
//  Copyright © 2019 Anobisoft. All rights reserved.
//

import UIKit

internal extension ImagePicker {
    
    class Delegate: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        var completion: Completion?
        var retainer: Any?
        
        init(retainer: Any, completion: @escaping Completion) {
            self.retainer = retainer // make retain cycle
            self.completion = completion
            super.init()
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let key: UIImagePickerController.InfoKey = picker.allowsEditing ? .editedImage : .originalImage
            let image = info[key] as? UIImage
            dismiss(picker: picker, image: image)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            dismiss(picker: picker)
        }
        
        func dismiss(picker: UIImagePickerController, image: UIImage? = nil) {
            completion?(image)
            completion = nil
            retainer = nil // release
            picker.dismiss(animated: true)
        }
    }
}
