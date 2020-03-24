//
//  ViewController.swift
//  SwanKit_macOS
//
//  Created by Stanislav Pletnev on 2019-27-11.
//  Copyright © 2019 Anobisoft. All rights reserved.
//

import Cocoa
import SwanKit

class ViewController: NSViewController {

    let recognizer = SpeechRecognizer { result in
        print(result)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func onButtonTap(_ sender: NSButton) {
        recognizer.startRecording()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    





}

