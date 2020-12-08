//
//  AppDelegate.swift
//  HoldThatSpace
//
//  Created by Mac on 4/15/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKCoreKit
import Stripe

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        //Facebook SignIn Integration
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        PayPalMobile.initializeWithClientIds(forEnvironments: [PayPalEnvironmentProduction: "AbBc9DXrXiyN2n9F6YgoW8hmA5WNbrlxERXb54MY8I2NzdxMOVvy3dg6VVcCC8CPFnT-deu4IFapLTkz", PayPalEnvironmentSandbox: "hamza@adixsoft.in"])
        Stripe.setDefaultPublishableKey("pk_test_korWN2idFeLThOwqvKLR1RPF")
        
        //Google SigIn
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        
        window = UIWindow(frame: UIScreen.main.bounds)
//         var initialViewController: UIViewController?
//         let status = UserDefaults.standard.value(forKey: "isSuccess") as! String
//        let emailId = UserDefaults.standard.value (forKey : "emailId") as! String
//        if status == "True" && emailId != ""{
//          initialViewController = AvailableSpaceViewController() as UIViewController
//        }else {
//        initialViewController = LoginViewController() as UIViewController
//        }
//        let navigationController = UINavigationController(rootViewController: initialViewController!)
//        navigationController.navigationBar.isHidden = true
        self.window?.rootViewController = MainNavigationController()
//  self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        AppEvents.activateApp()
    
    
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
      
        
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    
 
    
   //Handle URL Seession 
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        let handled = ApplicationDelegate.shared.application(application,
                                                             open: url,
                                                             sourceApplication: sourceApplication,
                                                             annotation: annotation)
        
        return handled || GIDSignIn.sharedInstance().handle(url,
                                                            sourceApplication: sourceApplication,
                                                            annotation: annotation)
        
        
    }

}
