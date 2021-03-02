//
//  AppDelegate.swift
//  TestTaskTurkcell
//
//  Created by Sergey Starushkin on 27.02.21.
//

import UIKit
import CoreData

@main class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = RootViewController()
        window?.makeKeyAndVisible()
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {}
    
    func applicationWillEnterForeground(_ application: UIApplication) {}
    
    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
    }
    
    func applicationWillResignActive(_ application: UIApplication) {}
    
    func applicationDidBecomeActive(_ application: UIApplication) {}
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
      let container = NSPersistentContainer(name: "TestTaskTurkcell")
    
      print("Documents Directory: ", FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last ?? "Not Found!")
      container.loadPersistentStores(completionHandler: { (storeDescription, error) in
        if let error = error as NSError? {
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
          let nserror = error as NSError
          fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
      }
    }
}
