//
//  Screens.swift
//  ScreenUI_UIKit
//
//  Created by Denis Koryttsev on 02.02.2021.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import ScreenUI
#if SWIFTUI
import SwiftUI
#endif

#if SWIFTUI
typealias Namespace = ScreenUI.SwiftUINamespace
typealias Platform = ScreenUI.SwiftUI
#elseif APPKIT
typealias Namespace = ScreenUI.AppKitNamespace
typealias Platform = ScreenUI.AppKit
#elseif UIKIT
typealias Namespace = ScreenUI.UIKitNamespace
typealias Platform = ScreenUI.UIKit
#endif

enum Screens {}
extension Screens: Namespace {}

extension Screens {
    typealias Router<S> = ScreenUI.Router<S> where S: ContentScreen
    typealias AnyTransition<From, To> = ScreenUI.AnyScreenTransition<From, To> where From: ContentScreen, To: ContentScreen
}

extension Screens {
    static var test: Void {
        ()
    }

    #if APPKIT
    typealias Push = Present
    #endif

    static let transitionsMap = Window(
        Tabs {
            Navigation(Tab1(nextScreen: AnyTransition(Push(DetailScreen(nextScreen: AnyTransition(Present(Navigation(DetailScreen(nextScreen: nil)))))))))
                .tabItem()
            Navigation(Tab2(nextScreen: AnyTransition(Present(Navigation(PresentedScreen())))))
                .tabItem()
        }
    )
}

struct Tab1: ContentScreen, ScreenAppearance {
    let title: String = "Tab1"
    var tabImage: Image? { if #available(iOS 13.0, *) { return Image(systemName: "person") } else { return nil } }
    let nextScreen: ScreenUI.AnyScreenTransition<Self, DetailScreen>

    func makeContent(_ context: Context, router: Router<NestedScreen>) -> ContentResult<Tab1> {
        #if UIKIT
        let vc = Content(state: router, context: context)
        #else
        let vc = Content(state: router)
        #endif
        return (vc, vc)
    }
    func updateContent(_ content: Content, with context: Context) {
        #if UIKIT
        content.context = context
        #endif
    }
    struct Context: Equatable {
        let text: String?
        init() { self.text = nil }
        init(text: String) { self.text = text }
    }
    typealias NestedScreen = Self
    #if SWIFTUI
        typealias Content = Tab1View
    #else
        typealias Content = Tab1ViewController
    #endif
}
struct Tab2: ContentScreen, ScreenAppearance {
    let title: String = "Tab2"
    var tabImage: Image? { if #available(iOS 13.0, *) { return Image(systemName: "gamecontroller") } else { return nil } }
    let nextScreen: ScreenUI.AnyScreenTransition<Self, PresentedScreen>

    func makeContent(_ context: Context, router: Router<NestedScreen>) -> ContentResult<Tab2> {
        let vc = Content(state: router)
        return (vc, vc)
    }
    struct Context: Equatable {}
    typealias NestedScreen = Self
    #if SWIFTUI
        typealias Content = Tab2View
    #else
        typealias Content = Tab2ViewController
    #endif
}
struct DetailScreen: ContentScreen, ScreenAppearance {
    let title: String = "Detail screen"

    let nextScreen: ScreenUI.AnyScreenTransition<Self, DetailScreen>?

    func makeContent(_ context: Context, router: Router<NestedScreen>) -> ContentResult<DetailScreen> {
        let vc = Content(state: router, context: context)
        return (vc, vc)
    }
    func updateContent(_ content: Content, with context: Context) {
        #if UIKIT
        content.text = context
        #endif
    }
    typealias Context = String
    typealias NestedScreen = Self
    #if SWIFTUI
        typealias Content = DetailView
    #else
        typealias Content = DetailViewController
    #endif
}

struct PresentedScreen: ContentScreen, ScreenAppearance {
    let title: String = "Presented screen"

    func makeContent(_ context: Context, router: Router<NestedScreen>) -> ContentResult<PresentedScreen> {
        let vc = Content(state: router, context: context)
        return (vc, vc)
    }
    func updateContent(_ content: Content, with context: Context) {
        #if !SWIFTUI
        content.context = context
        #endif
    }
    typealias Context = Color
    typealias NestedScreen = Self
    #if SWIFTUI
        typealias Content = PresentedView
    #else
        typealias Content = PresentedViewController
    #endif
}
