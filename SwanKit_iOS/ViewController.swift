//
//  ViewController.swift
//  SwanKit
//
//  Created by Stanislav Pletnev on 2019-27-11.
//  Copyright © 2019 Anobisoft. All rights reserved.
//

import UIKit
import SwanKit

class ViewController: UIViewController {

    let picker = ImagePicker()!
    let imageView = UIImageView.autolayout()

    override func viewDidLoad() {
        super.viewDidLoad()

        picker.additionalAlertActions = [ .init(title: "123") { _ in } ]
        ImagePicker.sourceTypesLocalizationMap = [
            .camera: "Camera".localized(.UIKit),
            .photoLibrary: "Photo Library".localized(.UIKit),
            .savedPhotosAlbum: "Saved Photos Album".localized(.UIKit),
        ]

        view.addSubview(imageView)
        [
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ].activate()
        imageView.contentMode = .scaleAspectFit
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let alert = UIAlertController(title: "OMG!!!", message: "ATATAT!", preferredStyle: .alert)
        alert.addCancel() { [unowned self] _ in
            self.show(self.picker, completion: self.imagePicked)
        }
        self.present(alert, animated: true)
    }

    func imagePicked(_ image: UIImage?) {
        imageView.image = image
    }

}

