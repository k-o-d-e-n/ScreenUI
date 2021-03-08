//
//  AppDelegate.swift
//  ScreenUI-MacOS
//
//  Created by Denis Koryttsev on 02.02.2021.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Cocoa
import ScreenUI

@main
final class AppDelegate: NSObject, NSApplicationDelegate, WindowStorage {
    var window: NSWindow?

    lazy var screens = AppScreen(Application(delegate: self, root: Screens.transitionsMap))

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        screens.router[root: (.init(), .init())].move(from: (), completion: nil)
        window?.title = "ScreenUI Example"
        window?.center()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool { true }
}

