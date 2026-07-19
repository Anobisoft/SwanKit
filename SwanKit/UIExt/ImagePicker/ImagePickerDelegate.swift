//
//  ImagePickerDelegate.swift
//  SwanKit
//
//  Created by Stanislav Pletnev on 2026-07-16.
//  Copyright © 2026 Anobisoft. Licensed under the MIT License.
//

import UIKit
import PhotosUI

extension ImagePicker {

    @MainActor
    final class Delegate: NSObject {
        private var handler: Handler?
        private var retainer: ImagePicker?
        private weak var presenter: UIViewController?

        init(retainer: ImagePicker, presenter: UIViewController, handler: @escaping Handler) {
            self.retainer = retainer // Establish controlled retain cycle intentionally
            self.presenter = presenter
            self.handler = handler
            super.init()
        }

        func deliver(result: PickerResult) {
            handler?(result)
            handler = nil
            retainer = nil
            presenter?.dismiss(animated: true)
        }
    }
}

// MARK: - Legacy UIImagePickerControllerDelegate Conformance (Camera Operations)

extension ImagePicker.Delegate: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    public func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        if let image = (info[.editedImage] as? UIImage) ?? (info[.originalImage] as? UIImage) {
            deliver(result: .camera(image))
        } else {
            deliver(result: .cancelled)
        }
    }

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        deliver(result: .cancelled)
    }
}

// MARK: - Modern PHPickerViewControllerDelegate Conformance (Library Multi-selection)

extension ImagePicker.Delegate: PHPickerViewControllerDelegate {

    public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        guard !results.isEmpty else {
            deliver(result: .cancelled)
            return
        }

        if results.count == 1 {
            deliver(result: .pickerSingle(results[0]))
        } else {
            deliver(result: .pickerMultiple(results))
        }
    }
}
