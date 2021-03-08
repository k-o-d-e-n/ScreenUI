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

    #if SWIFTUI
    static var tab1: MapContent<Navigation<Tab1>, AnyView> {
        Navigation(Tab1(nextScreen: AnyTransition(Push(DetailScreen(nextScreen: AnyTransition(Present(DetailScreen(nextScreen: nil))))))))
            .mapContent({ ctn, _, tab -> AnyView in
                AnyView(ctn.tabItem { Text(tab[next: \.title]) })
            })
    }
    static var tab2: MapContent<Navigation<Tab2>, AnyView> {
        Navigation(Tab2(nextScreen: AnyTransition(Present(Navigation(PresentedScreen())))))
            .mapContent({ ctn, _, tab -> AnyView in
                AnyView(ctn.tabItem { Text(tab[next: \.title]) })
            })
    }
    #else
    static var tab1: Navigation<Tab1> {
        Navigation(Tab1(nextScreen: AnyTransition(Push(DetailScreen(nextScreen: AnyTransition(Present(Navigation(DetailScreen(nextScreen: nil)))))))))
    }
    static var tab2: Navigation<Tab2> {
        Navigation(Tab2(nextScreen: AnyTransition(Present(Navigation(PresentedScreen())))))
    }
    #endif

    static let transitionsMap = Window(
        Tabs {
            tab1
            tab2
        }
    )
}

struct Tab1: ContentScreen {
    let title: String = "Tab1"
    let nextScreen: ScreenUI.AnyScreenTransition<Self, DetailScreen>

    func makeContent(_ context: Context, router: Router<NestedScreen>) -> ContentResult<Tab1> {
        let vc = Content(state: router)
        return (vc, vc)
    }
    struct Context: Equatable {}
    typealias NestedScreen = Self
    #if SWIFTUI
        typealias Content = Tab1View
    #else
        typealias Content = Tab1ViewController
    #endif
}
struct Tab2: ContentScreen {
    let title: String = "Tab2"
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
struct DetailScreen: ContentScreen {
    let title: String = "Detail screen"
    /// var back: AnyBackTransition<BackSurface>?

    let nextScreen: ScreenUI.AnyScreenTransition<Self, DetailScreen>?

    func makeContent(_ context: Context, router: Router<NestedScreen>) -> ContentResult<DetailScreen> {
        let vc = Content(state: router, context: context)
        return (vc, vc)
    }
    typealias Context = String
    typealias NestedScreen = Self
    #if SWIFTUI
        typealias Content = DetailView
    #else
        typealias Content = DetailViewController
    #endif
}

struct PresentedScreen: ContentScreen {
    let title: String = "Presented screen"
    /// var back: AnyBackTransition<BackSurface>?

    func makeContent(_ context: Context, router: Router<NestedScreen>) -> ContentResult<PresentedScreen> {
        let vc = Content(state: router, context: context)
        return (vc, vc)
    }
    typealias Context = Color
    typealias NestedScreen = Self
    #if SWIFTUI
        typealias Content = PresentedView
    #else
        typealias Content = PresentedViewController
    #endif
}
