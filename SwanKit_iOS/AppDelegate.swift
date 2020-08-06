//
//  AppDelegate.swift
//  SwanKit
//
//  Created by Stanislav Pletnev on 2019-27-11.
//  Copyright © 2019 Anobisoft. All rights reserved.
//

import UIKit
import SwanKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        print(Bundle.appName, Version.application.string())
        
        let service = Keychain.Service(id: "SwanKit")
        try? service.save(account: "OMG!", password: "ATATAT!")
        print(try? service.fetchPasswords())
        
        let viewController = UIViewController()
        viewController.view.backgroundColor = .red
        application.rootViewController = viewController
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            let viewController = ViewController()
            viewController.view.backgroundColor = .blue
            application.rootViewController = viewController
        }

        return true
    }
    
    

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication,
                     didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


    func exampleFileStorage() {
        do {
            let key = "OMG!"
            let storage = try FileStorage(path: "at\\/////a??_+-&*tat")
            try storage.save("ATATAT!!!".data(using: .utf8)!, forKey: key)
            if let data: Data = storage.data(forKey: key) {
                if let omg = String(data: data, encoding: .utf8) {
                    print(omg)
                } else {
                    print("decoded string is nil")
                }
            } else {
                print("no data")
            }
        } catch {
            print(error)
        }
    }

    func exampleCache() {
        let cache = Cache<NSString, NSData>()
        cache.totalCostLimit = 20000
        cache.delegate = self

        for i in 1...10000 {
            let key = String(i)
            cache[NSString(string: key)] = NSData(data: key.data(using: .utf8)!)
        }

        var arr = [NSData]()
        for i in 1...10000 {
            let key = String(i)
            if let cached = cache[NSString(string: key)] {
                arr.append(cached)
            }
        }

        print(arr.count)
    }

}

extension AppDelegate: CacheDelegate {
    func cache<KeyType: AnyObject, ObjectType: AnyObject>(_ cache: Cache<KeyType, ObjectType>, willEvict object: ObjectType) {
        print(object)
    }
}
