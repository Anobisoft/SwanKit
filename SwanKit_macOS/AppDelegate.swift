//
//  AppDelegate.swift
//  SwanKit_macOS
//
//  Created by Stanislav Pletnev on 2019-27-11.
//  Copyright © 2019 Anobisoft. All rights reserved.
//

import Cocoa
import SwanKit

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        Access.video.accessRequest { granted in
            if granted {
                print("granted")
            } else {
                print("denny")
            }
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

}

