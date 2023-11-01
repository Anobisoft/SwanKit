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

    let picker = ImagePicker()
    let imageView = UIImageView.autolayout()

    override func viewDidLoad() {
        super.viewDidLoad()

        picker?.additionalAlertActions = [ .init(title: "123") { _ in } ]
        picker?.sourceTypesLocalizationMap = [
            .camera: "Camera".localized(),
            .photoLibrary: "Photo Library".localized()
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

        guard let picker = self.picker else { return }
        self.show(picker, handler: self.imagePicked)
    }

    func imagePicked(_ image: UIImage?) {
        imageView.image = image
    }

}

