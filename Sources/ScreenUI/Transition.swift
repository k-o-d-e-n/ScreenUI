//
//  Transition.swift
//  Pods
//
//  Created by Denis Koryttsev on 02.03.2021.
//

import Foundation
#if canImport(SwiftUI)
import SwiftUI
#endif

public protocol BackTransition {
    associatedtype From: Screen
    func move(from content: From.Content, completion: (() -> Void)?)
}
extension BackTransition {
    public func move(from content: From.Content) {
        move(from: content, completion: nil)
    }
}
public struct NeverBack<From>: BackTransition where From: Screen {
    public func move(from content: From.Content, completion: (() -> Void)?) {}
}
public class AnyBackTransition<From>: BackTransition where From: Screen {
    public func move(from surface: From.Content, completion: (() -> Void)?) { fatalError("unimplemented") }

    public static func some<Base>(_ base: Base) -> AnyBackTransition<Base.From> where Base: BackTransition {
        SomeBackTransition<Base>(base: base)
    }
}
final class SomeBackTransition<ST: BackTransition>: AnyBackTransition<ST.From>, CustomDebugStringConvertible {
    let base: ST
    init(base: ST) { self.base = base }
    override func move(from surface: ST.From.Content, completion: (() -> Void)?) {
        base.move(from: surface, completion: completion)
    }
    var debugDescription: String { String(describing: base) }
}

/// -------------

public typealias TransitionResult<From, To> = (state: TransitionState<From, To>, content: ContentResult<To>) where From: Screen, To: Screen
public protocol Transition: PathProvider where PathFrom == To.PathFrom {
    associatedtype From: Screen
    associatedtype To: Screen
    associatedtype Context

    func move(from screen: From.Content, state: ContentScreenState<From.NestedScreen>, with context: Context, completion: (() -> Void)?) -> TransitionResult<From, To>
    func hierarchyTest(from fromContent: From.Content, to toContent: To.NestedScreen.Content) -> Bool
    func updateContent(_ content: To.Content, context: Context)
}
extension Transition {
    public func updateContent(_ content: To.Content, context: Context) {}
}
extension Transition where Context == To.Context, PathFrom == To {
    public func updateContent(_ content: To.Content, context: Context) { self[next: \.self].updateContent(content, with: context) }
}
extension Transition {
    public func hierarchyTest(from fromContent: From.Content, to toContent: To.NestedScreen.Content) -> Bool { true }
}
public protocol ScreenTransition: Transition where From: ContentScreen, To: ContentScreen { // TODO: `From` really must be ContentScreen?
    /// associatedtype StateEvaluator
    /// associatedtype Back
    /// associatedtype Shift
    /// var shift: Shift { get }
}

/// -----------

class _AnyTransition_<From, Context, To>: UnknownPathProvider where From: Screen, To: Screen {
    func move(from screen: From.Content, state: ContentScreenState<From.NestedScreen>, with context: Context, completion: (() -> Void)?) -> TransitionResult<From, To> { fatalError("unimplemented") }
    func hierarchyTest(from fromContent: From.Content, to toContent: To.NestedScreen.Content) -> Bool { fatalError("unimplemented") }
    func updateContent(_ content: To.Content, context: Context) { fatalError("unimplemented") }
    subscript<U, T>(next path: KeyPath<U, T>) -> T { fatalError("unimplemented") }
    func index<U>(of keyPath: PartialKeyPath<U>) -> Int { fatalError("unimplemented") }
    func keyPath<U,T>(at index: Int) -> KeyPath<U, T> { fatalError("unimplemented") }

    #if canImport(SwiftUI) && canImport(Combine)
    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
    func move<V>(_ state: Binding<Bool>, screenState: ContentScreenState<To.NestedScreen>, actionView: V, context: Context, completion: (() -> Void)?)
    -> AnyView where V: View {
        fatalError("unimplemented")
    }
    #endif
}
final class __AnyTransition_<Base>: _AnyTransition_<Base.From, Base.Context, Base.To> where Base: Transition {
    let base: Base
    init(base: Base) {
        self.base = base
    }
    override subscript<U, T>(next path: KeyPath<U, T>) -> T { base[next: path as! KeyPath<Base.PathFrom, T>] }
    override func index<U>(of keyPath: PartialKeyPath<U>) -> Int { base.index(of: keyPath as! PartialKeyPath<Base.PathFrom>) }
    override func keyPath<U,T>(at index: Int) -> KeyPath<U, T> { base.keyPath(at: index) as! KeyPath<U, T> }
    override func move(from screen: Base.From.Content, state: ContentScreenState<Base.From.NestedScreen>, with context: Base.Context, completion: (() -> Void)?) -> TransitionResult<Base.From, Base.To> {
        base.move(from: screen, state: state, with: context, completion: completion)
    }
    override func hierarchyTest(from fromContent: Base.From.Content, to toContent: Base.To.NestedScreen.Content) -> Bool {
        base.hierarchyTest(from: fromContent, to: toContent)
    }
    override func updateContent(_ content: Base.To.Content, context: Base.Context) { base.updateContent(content, context: context) }
}

public struct AnyScreenTransition<From, To>: ScreenTransition where From: ContentScreen, To: ContentScreen {
    let base: _AnyTransition_<From, To.Context, To>

    public init<Base>(_ base: Base) where Base: ScreenTransition, Base.From == From, Base.To == To, Base.Context == Base.To.Context {
        self.base = __AnyTransition_(base: base)
    }

    public subscript<T>(next path: KeyPath<To.PathFrom, T>) -> T { base[next: path] }
    public func index(of keyPath: PartialKeyPath<To.PathFrom>) -> Int { base.index(of: keyPath) }
    public func keyPath(at index: Int) -> PartialKeyPath<To.PathFrom> { base.keyPath(at: index) }
    public func move(from screen: From.Content, state: ContentScreenState<From.NestedScreen>, with context: To.Context, completion: (() -> Void)?) -> TransitionResult<From, To> {
        base.move(from: screen, state: state, with: context, completion: completion)
    }
    public func hierarchyTest(from fromContent: From.Content, to toContent: To.NestedScreen.Content) -> Bool {
        base.hierarchyTest(from: fromContent, to: toContent)
    }
    public func updateContent(_ content: To.Content, context: To.Context) {
        base.updateContent(content, context: context)
    }
}
public struct PreciseTransition<From, Too>: ScreenTransition where From: ContentScreen, Too: Screen {
    public typealias To = Too.NestedScreen
    public typealias Context = Too.Context
    let base: _AnyTransition_<From, Too.Context, Too.NestedScreen>

    public init<Base>(_ base: Base) where Base: ScreenTransition, Base.From == From, Base.To == Too.NestedScreen, Base.Context == Too.Context {
        self.base = __AnyTransition_(base: base)
    }

    public subscript<T>(next path: KeyPath<To.PathFrom, T>) -> T { base[next: path] }
    public func index(of keyPath: PartialKeyPath<To.PathFrom>) -> Int { base.index(of: keyPath) }
    public func keyPath(at index: Int) -> PartialKeyPath<To.PathFrom> { base.keyPath(at: index) }
    public func move(from screen: From.Content, state: ContentScreenState<From.NestedScreen>, with context: Context, completion: (() -> Void)?) -> TransitionResult<From, Too.NestedScreen> {
        base.move(from: screen, state: state, with: context, completion: completion)
    }
    public func hierarchyTest(from fromContent: From.Content, to toContent: To.NestedScreen.Content) -> Bool {
        base.hierarchyTest(from: fromContent, to: toContent)
    }
    public func updateContent(_ content: To.Content, context: Too.Context) {
        base.updateContent(content, context: context)
    }
}
public struct AnyTransition<From, Context, To>: Transition where From: Screen, To: Screen {
    let base: _AnyTransition_<From, Context, To>

    public init<Base>(_ base: Base) where Base: Transition, Base.From == From, Base.To == To, Base.Context == Context {
        self.base = __AnyTransition_(base: base)
    }

    public subscript<T>(next path: KeyPath<To.PathFrom, T>) -> T { base[next: path] }
    public func index(of keyPath: PartialKeyPath<To.PathFrom>) -> Int { base.index(of: keyPath) }
    public func keyPath(at index: Int) -> PartialKeyPath<To.PathFrom> { base.keyPath(at: index) }
    public func move(from screen: From.Content, state: ContentScreenState<From.NestedScreen>, with context: Context, completion: (() -> Void)?) -> TransitionResult<From, To> {
        base.move(from: screen, state: state, with: context, completion: completion)
    }
    public func hierarchyTest(from fromContent: From.Content, to toContent: To.NestedScreen.Content) -> Bool {
        base.hierarchyTest(from: fromContent, to: toContent)
    }
    public func updateContent(_ content: To.Content, context: Context) {
        base.updateContent(content, context: context)
    }
}
extension AnyTransition: ScreenTransition where From: ContentScreen, To: ContentScreen {}

#if canImport(SwiftUI) && canImport(Combine)
final class __AnyTransition_SwiftUI<Base>: _AnyTransition_<Base.From, Base.Context, Base.To> where Base: SwiftUICompatibleTransition {
    let base: Base
    init(base: Base) {
        self.base = base
    }
    override subscript<U, T>(next path: KeyPath<U, T>) -> T { base[next: path as! KeyPath<Base.PathFrom, T>] }
    override func move(from screen: Base.From.Content, state: ContentScreenState<Base.From.NestedScreen>, with context: Base.Context, completion: (() -> Void)?) -> TransitionResult<Base.From, Base.To> {
        base.move(from: screen, state: state, with: context, completion: completion)
    }

    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
    override func move<V>(_ state: Binding<Bool>, screenState: ContentScreenState<Base.To.NestedScreen>, actionView: V, context: Base.Context, completion: (() -> Void)?)
    -> AnyView where V: View {
        base.move(state, screenState: screenState, actionView: actionView, context: context, completion: completion)
    }
}
extension AnyScreenTransition: SwiftUICompatibleTransition {
    public init<Base>(_ base: Base) where Base: SwiftUICompatibleTransition, Base.From == From, Base.To == To, Base.Context == Base.To.Context {
        self.base = __AnyTransition_SwiftUI(base: base)
    }
    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
    public func move<V>(_ state: Binding<Bool>, screenState: ContentScreenState<To.NestedScreen>, actionView: V, context: To.Context, completion: (() -> Void)?)
    -> AnyView where V : View {
        base.move(state, screenState: screenState, actionView: actionView, context: context, completion: completion)
    }
}
extension PreciseTransition: SwiftUICompatibleTransition {
    public init<Base>(_ base: Base) where Base: SwiftUICompatibleTransition, Base.From == From, Base.To == To, Base.Context == Context {
        self.base = __AnyTransition_SwiftUI(base: base)
    }
    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
    public func move<V>(_ state: Binding<Bool>, screenState: ContentScreenState<To.NestedScreen>, actionView: V, context: Too.Context, completion: (() -> Void)?)
    -> AnyView where V : View {
        base.move(state, screenState: screenState, actionView: actionView, context: context, completion: completion)
    }
}
extension AnyTransition: SwiftUICompatibleTransition {
    public init<Base>(_ base: Base) where Base: SwiftUICompatibleTransition, Base.From == From, Base.To == To, Base.Context == Context {
        self.base = __AnyTransition_SwiftUI(base: base)
    }
    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
    public func move<V>(_ state: Binding<Bool>, screenState: ContentScreenState<To.NestedScreen>, actionView: V, context: Context, completion: (() -> Void)?)
    -> AnyView where V : View {
        base.move(state, screenState: screenState, actionView: actionView, context: context, completion: completion)
    }
}
#endif
