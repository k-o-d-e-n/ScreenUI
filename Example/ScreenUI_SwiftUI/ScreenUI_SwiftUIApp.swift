//
//  ScreenUI_SwiftUIApp.swift
//  ScreenUI-SwiftUI
//
//  Created by Denis Koryttsev on 02.02.2021.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import SwiftUI
import ScreenUI

@main
struct ScreenUI_SwiftUIApp: App, SwiftUINamespace {
    let screens = AppScreen(Screens.transitionsMap)

    var body: some Scene {
        screens.makeBody((.init(), .init()))
    }

    init() {
        if true {
            delayedMove()
        }
    }

    func delayedMove() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
            screens.router[select: \.1][move: \.nextScreen].move(from: (), completion: nil)
        }
    }
}
