//
//  AppDelegate.swift
//  Music Link
//
//  Created by uuttff8 on 8/29/19.
//  Copyright © 2019 uuttff8. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var orientationLock = UIInterfaceOrientationMask.portrait
    
    var optionallyStoreTheFirstLaunchFlag = false

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        optionallyStoreTheFirstLaunchFlag = UIApplication.isFirstLaunch()

        
        initDeepLinks(application: application)
        initControllers(application: application)
        
        
        return true
    }
    
    //deep link handling
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        if userActivity.webpageURL != nil {
            if(userActivity.activityType == NSUserActivityTypeBrowsingWeb) {
                let _ = userActivity.webpageURL
            }
        }
        return false
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return self.orientationLock
    }
    
    private func initDeepLinks(application: UIApplication) {
        if userActivity?.activityType == NSUserActivityTypeBrowsingWeb {
            if (userActivity?.webpageURL) != nil {
                print(userActivity?.webpageURL ?? "")
            }
        }
    }
    
    private func initControllers(application: UIApplication) {
        if optionallyStoreTheFirstLaunchFlag {
            // TODO(uuttff8): build splash screen
            print("first run")
            window?.rootViewController = ScreenRouter.shared.getSplashController()
        } else {
            print("not first run")
            window?.rootViewController = ScreenRouter.shared.getMainTabBarController()
        }
        
        window?.makeKeyAndVisible()
    }
    
    

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Music_Link")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

