//
//  AppDelegate.swift
//  ScreenUI
//
//  Created by k-o-d-e-n on 02/02/2021.
//  Copyright (c) 2021 k-o-d-e-n. All rights reserved.
//

import UIKit
import ScreenUI

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate, WindowStorage {
    var window: UIWindow?

    lazy var screens = InitialScreen(Application(delegate: self, root: Screens.transitionsMap))

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        screens.router
            .root(.init(root: (.init(), .init())))
            .select(\.1)
            .move(\.nextScreen, .red)
            .move(from: (), completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
            self.screens.router[root: .init(root: (tab1: .init(text: "UPDATED TEXT"), tab2: .init()))][select: \.1][move: \.nextScreen, .brown].move(from: (), completion: nil)
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

