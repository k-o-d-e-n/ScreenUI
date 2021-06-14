//
//  Conveniences.swift
//  Pods
//
//  Created by Denis Koryttsev on 05.03.2021.
//

import Foundation
#if canImport(SwiftUI)
import SwiftUI
#endif

protocol _ScreenBuilder: PathProvider {
    var _0: PathFrom { get }
}
extension _ScreenBuilder {
    public subscript<T>(next path: KeyPath<PathFrom, T>) -> T {
        _0[keyPath: path]
    }
}
public protocol ScreenBuilder: PathProvider {
    associatedtype Content
    associatedtype Context

    func makeContent<From>(_ context: Context, router: Router<From>) -> Content where From.PathFrom == PathFrom
    func updateContent(_ content: Content, with context: Context)
}
extension ScreenBuilder {
    public func updateContent(_ content: Content, with context: Context) {}
    public func makeContent<From, T>(at path: KeyPath<PathFrom, T>, isActive: Bool, context: T.Context, router: Router<From>) -> T.Content
    where PathFrom == From.PathFrom, From : ContentScreen, T: Screen {
        let (r, state) = router.__next(path: path, isActive: isActive)
        let (c1, c0) = self[next: path].makeContent(context, router: r)
        state.surface = c0
        state.surfaceWrapper = c1
        return c1
    }
}

@resultBuilder
public struct ContentBuilder {}


#if SCREENUI_BETA
public protocol ScreenItemsBuilder: PathProvider {
    associatedtype ItemContent
    associatedtype Context
    func makeContent<From>(at index: Int, context: Context, router: Router<From>) -> ItemContent where From.PathFrom == PathFrom
}
extension OneController: ScreenItemsBuilder {
    public func makeContent<From>(at index: Int, context: Context, router: Router<From>) -> S.Content where From : ContentScreen, Self.PathFrom == From.PathFrom {
        let (c1, _) = _0.makeContent(context, router: router.next(path: \._0, isActive: true))
        return c1
    }
}
extension TwoController: ScreenItemsBuilder {
    public typealias ItemContent = Controller
    public func makeContent<From>(at index: Int, context: Context, router: Router<From>) -> ItemContent where From : ContentScreen, Self.PathFrom == From.PathFrom {
        let c1: Controller
        switch index {
        case 1: c1 = makeContent(at: \.1, isActive: true, context: context.1, router: router)
        default: c1 = makeContent(at: \.0, isActive: true, context: context.0, router: router)
        }
        return c1
    }
}
#endif
