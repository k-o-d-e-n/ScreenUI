//
//  Custom.swift
//  ScreenUI
//
//  Created by Denis Koryttsev on 07.03.2021.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import ScreenUI

#if APPKIT
struct Navigation<S>: Screen where S: Screen {
    typealias Content = S.Content
    typealias Context = S.Context
    typealias NestedScreen = S.NestedScreen

    let base: S
    init(_ base: S) {
        self.base = base
    }

    subscript<T>(next path: KeyPath<S.PathFrom, T>) -> T {
        base[next: path]
    }

    func makeContent(_ context: Context, router: Router<NestedScreen>) -> ContentResult<Navigation<S>> {
        base.makeContent(context, router: router)
    }
}
#endif

protocol AppWindow {
    func makeKeyAndVisible()
}
#if UIKIT
extension UIWindow: AppWindow {}
#elseif APPKIT
extension NSWindow: AppWindow {
    func makeKeyAndVisible() {
        makeKeyAndOrderFront(nil)
    }
}
#endif
protocol WindowStorage: AnyObject {
    associatedtype Win: AppWindow
    var window: Win? { set get }
}
struct WindowInit<From, Too>: ScreenTransition where From: ContentScreen, From.Content: WindowStorage, Too: Screen, Too.Content == From.Content.Win {
    typealias To = Too.NestedScreen
    let to: Too

    subscript<T>(next path: KeyPath<To.PathFrom, T>) -> T {
        to[next: path]
    }

    func move(from screen: From.Content, state: ScreenState<From.NestedScreen>, with context: Too.Context, completion: (() -> Void)?) -> TransitionResult<To> {
        let state = ScreenState<To>()
        let (c1, c0) = to.makeContent(context, router: .router(from: to, with: state))
        screen.window = c1
        c1.makeKeyAndVisible()
        return (state, c0)
    }
}
extension WindowInit {
    func index(of keyPath: PartialKeyPath<To.PathFrom>) -> Int { to.index(of: keyPath) }
    func keyPath(at index: Int) -> PartialKeyPath<To.PathFrom> { to.keyPath(at: index) }
}

#if APPKIT || UIKIT
struct Application<Delegate, Root>: ScreenContainer where Root: Screen, Delegate: WindowStorage, Root.Content == Delegate.Win {
    typealias Content = Delegate
    typealias Context = Root.Context
    typealias NestedScreen = Root.NestedScreen
    weak var delegate: Delegate!
    let root: Root

    subscript<T>(next path: KeyPath<Root.PathFrom, T>) -> T { root[next: path] }
    public func index(of keyPath: PartialKeyPath<Root.PathFrom>) -> Int { root.index(of: keyPath) }
    public func keyPath(at index: Int) -> PartialKeyPath<Root.PathFrom> { root.keyPath(at: index) }

    func makeContent(_ context: Context, router: Router<NestedScreen>) -> ContentResult<Self> {
        let (c1, c0) = root.makeContent(context, router: router)
        delegate.window = c1
        c1.makeKeyAndVisible()
        return (delegate, c0)
    }
}
#endif
