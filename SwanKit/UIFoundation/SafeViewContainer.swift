//
//  SafeViewContainer.swift
//  SwanKit
//
//  Created by Stanislav Pletnev on 2019-25-11.
//  Copyright © 2019 Anobisoft. All rights reserved.
//

import UIKit

@available(iOS 9.0, *)
public class SafeViewContainer: UIViewController {
    
    public init(plugin: UIViewController) {
        super.init(nibName: nil, bundle: nil)
        
        addChild(plugin)
        self.view.addSubview(plugin.view)
        plugin.view.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11.0, tvOS 11.0, *) {
            NSLayoutConstraint.activate([
                plugin.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                plugin.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                plugin.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                plugin.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            ])
        } else {
            NSLayoutConstraint.activate([
                plugin.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                plugin.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                plugin.view.topAnchor.constraint(equalTo: self.topLayoutGuide.topAnchor),
                plugin.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            ])
        }
        plugin.didMove(toParent: self)
        self.view.backgroundColor = plugin.view.backgroundColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
