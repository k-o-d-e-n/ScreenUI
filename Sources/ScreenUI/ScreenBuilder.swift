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

    func makeContent<From>(_ context: Context, router: Router<From>) -> Content where From: Screen, From.PathFrom == PathFrom
}
extension ScreenBuilder {
    public func makeContent<From, T>(at path: KeyPath<PathFrom, T>, context: T.Context, router: Router<From>) -> T.Content
    where PathFrom == From.PathFrom, From : ContentScreen, T: Screen {
        let screen = self[next: path]
        return screen.makeContent(context, router: router.next(from: screen, path: path, isActive: true)).contentWrapper
    }
}

@_functionBuilder
public struct ContentBuilder {}

extension ContentBuilder {
    /// public static func buildBlock<CB>(_ cb: CB) -> TupleScreen<CB> where CB: ContentBuilder {
    ///     TupleScreen(tuple: cb)
    /// }
}
