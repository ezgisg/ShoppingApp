//
//  AppDelegate.swift
//  ShoppingApp
//
//  Created by Ezgi Sümer Günaydın on 22.07.2024.
//

import UIKit
import Base
import CoreData
import Common
import Firebase
import FirebaseCore
import FirebaseFirestore
import GoogleSignIn
import Network
import Onboarding
import Coordinator

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    lazy var appCoordinator = AppCoordinator(window: &window)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        ReachabilityManager.shared.startNetworkReachabilityObserver { [weak self] status in
            guard let self else { return }
            switch status {
            case true:
                break
            case false:
                showConnectionAlert()
            }
        }
        
        appCoordinator.start()

        return true
    }
    
    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey: Any] = [:]
    ) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "ShoppingApp")
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

//TODO: buradan onboarding kaldırılıp localizable ı başka yere alınacak
private extension AppDelegate {
    final func showConnectionAlert() {
        guard let topViewController = UIApplication.topViewController() as? BaseViewController else { return }
        topViewController.showAlert(title: L10nOnboarding.NoConnection.title.localized(), message: L10nOnboarding.NoConnection.message.localized(), buttonTitle: L10nOnboarding.NoConnection.tryAgain.localized()) { [weak self] in
            guard let self,
                 !ReachabilityManager.shared.isConnectedToInternet() else { return }
            showConnectionAlert()
        }
    }
}



