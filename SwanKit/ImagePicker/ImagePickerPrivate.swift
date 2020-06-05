//
//  ImagePickerPrivate.swift
//  SwanKit
//
//  Created by Stanislav Pletnev on 2019-12-03.
//  Copyright © 2019 Anobisoft. All rights reserved.
//

import UIKit

extension ImagePicker {
    
    func show(on viewController: UIViewController, handler: @escaping Handler) {

        delegate = Delegate(retainer: self, handler: handler) // retain
        presenter = viewController
        
        if availableSources.count == 1 && (additionalAlertActions == nil || additionalAlertActions!.count == 0) {
            self.selectSource(sourceType: availableSources.first!)
        } else {
            showAlert()
        }
    }
    
    private func showAlert() {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        if let additionalActions = additionalAlertActions {
            for action in additionalActions {
                let alertAction = UIAlertAction(title: action.title, style: action.style) { [unowned self] _ in
                    self.delegate = nil //release
                    action.handler?(action.tag)
                }
                alert.addAction(alertAction)
            }
        }

        for source in availableSources {
            let action = UIAlertAction(title: sourceTypesLocalizationMap[source], style: .default) { [unowned self] _ in
                self.selectSource(sourceType: source)
            }
            alert.addAction(action)
        }

        let cancel = UIAlertAction(title: cancelButtonTitle, style: .cancel) { [unowned self] _ in
            self.delegate = nil //release
        }
        alert.addAction(cancel)
        
        presenter?.present(alert, animated: true) { [unowned self] in
            alert.view.superview?.isUserInteractionEnabled = true
            let tapRecognizer = UITapGestureRecognizer(target: self,
                                                       action: #selector(self.alertControllerBackgroundTapped))
            alert.view.superview?.addGestureRecognizer(tapRecognizer)
        }
    }
    
    @objc private func alertControllerBackgroundTapped() {
        self.delegate = nil //release
        presenter?.dismiss(animated: true, completion: nil)
    }
    
    private func selectSource(sourceType: UIImagePickerController.SourceType) {
        
        let completion: Access.Completion = { [unowned self] granted in
            if granted {
                self.accessSuccess(sourceType: sourceType)
            } else {
                self.delegate = nil
            }
        }
        
        switch sourceType {
        case .camera:
            Access.video.accessRequest(completion: completion)
        default:
            Access.photoLibrary.accessRequest(completion: completion)
        }
    }
    
    private func accessSuccess(sourceType: UIImagePickerController.SourceType) {
        guard let presenter = presenter else { return }
        
        let controller = UIImagePickerController()
        controller.delegate = delegate
        
        let iPad: Bool = UIDevice.current.userInterfaceIdiom == .pad
        controller.allowsEditing = self.allowsEditing && (!iPad || sourceType == .camera)
        controller.sourceType = sourceType
        
        switch sourceType {
        case .camera:
            controller.cameraDevice = self.cameraDevice
            controller.cameraFlashMode = self.cameraFlashMode
        default:
            break
        }
        
        presenter.present(controller, animated: true)
    }
    
}
