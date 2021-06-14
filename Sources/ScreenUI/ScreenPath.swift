//
//  ScreenPath.swift
//  Pods
//
//  Created by Denis Koryttsev on 02.03.2021.
//

import Foundation

protocol ScreenPathPrivate {
    var _state: AnyScreenState? { get }
}
public protocol ScreenPathPrivate2 {
    associatedtype From: Screen
    associatedtype Result
    /// Do not call directly
    @discardableResult
    func __move(from content: From.Content, completion: (() -> Void)?) -> Result
}
public protocol ScreenPath: PathProvider where PathFrom == To.PathFrom {
    associatedtype From: Screen
    associatedtype To: Screen
    associatedtype Result
    @discardableResult
    func move(from content: From.Content, completion: (() -> Void)?) -> Result
}
extension AnyScreenState {
    func _backFurther(completion: (() -> Void)?) {
        var topState: AnyScreenState? = self
        while let n = topState?.next {
            topState = n
        }
        var previous = topState
        while let p = previous, p !== self {
            previous = p.previous
            p.back(completion: nil)
            p.previous = nil
        }
    }
}

/// -----------

public typealias ScreenPathResult<To> = (state: AnyScreenState, screenContent: To.NestedScreen.Content) where To: Screen
public struct StartPath<T>: ScreenPath, ScreenPathPrivate, ScreenPathPrivate2 where T: Transition {
    public typealias From = T.From
    public typealias To = T.To

    let keyPath: PartialKeyPath<T.From.PathFrom>
    let transition: T
    let context: ContextStrategy
    let state: ContentScreenState<T.From.NestedScreen>
    var _state: AnyScreenState? { state }

    enum ContextStrategy {
        case weak
        case strong(T.Context)
    }

    public subscript<T>(next path: KeyPath<To.PathFrom, T>) -> T { transition[next: path] }

    public func __move(from surface: T.From.Content, completion: (() -> Void)?) -> ScreenPathResult<T.To> {
        guard
            let next = state.next,
            next.keyPath == keyPath,
            let content = next.content.map({ $0 as! ContentResult<T.To> }),
            transition.hierarchyTest(from: surface, to: content.screenContent)
        else {
            guard case .strong(let ctx) = context else { fatalError("The screen was not found in the hierarchy and cannot be created, because the context was not provided") }
            let (nextState, content) = transition.move(from: surface, state: state, with: ctx, completion: completion)
            nextState.keyPath = keyPath
            nextState.surface = content.screenContent
            nextState.surfaceWrapper = content.contentWrapper
            nextState.previous = _state
            state.next = nextState
            return (nextState, content.screenContent)
        }
        if case .strong(let ctx) = context {
            transition.updateContent(content.contentWrapper, context: ctx)
        }
        return (next, content.screenContent)
    }
    @discardableResult
    public func move(from surface: T.From.Content, completion: (() -> Void)?) -> ScreenPathResult<T.To> {
        _state?.next?._backFurther(completion: nil)
        return __move(from: surface, completion: completion)
    }
}
extension StartPath {
    public func index(of keyPath: PartialKeyPath<To.PathFrom>) -> Int { transition.index(of: keyPath) }
    public func keyPath(at index: Int) -> PartialKeyPath<To.PathFrom> { transition.keyPath(at: index) }
}
extension Router {
    public subscript<T>(move path: KeyPath<PathFrom, T>, ctx: T.Context) -> StartPath<T> where T: Transition, T.From == From.NestedScreen {
        StartPath<T>(keyPath: path, transition: self[next: path], context: .strong(ctx), state: state)
    }
    public subscript<T>(move path: KeyPath<PathFrom, Optional<T>>, ctx: T.Context) -> StartPath<T>? where T: Transition, T.From == From.NestedScreen {
        guard let transition = self[next: path] else { return nil }
        return StartPath<T>(keyPath: path, transition: transition, context: .strong(ctx), state: state)
    }
    public subscript<T>(move path: KeyPath<PathFrom, T>) -> StartPath<T> where T: Transition, T.From == From.NestedScreen {
        StartPath<T>(keyPath: path, transition: self[next: path], context: .weak, state: state)
    }
    public subscript<T>(move path: KeyPath<PathFrom, Optional<T>>) -> StartPath<T>? where T: Transition, T.From == From.NestedScreen {
        guard let transition = self[next: path] else { return nil }
        return StartPath<T>(keyPath: path, transition: transition, context: .weak, state: state)
    }
}
public struct NextPath<Prev, T>: ScreenPath, ScreenPathPrivate, ScreenPathPrivate2
where Prev: ScreenPath & ScreenPathPrivate2, T: Transition, T.From == Prev.To.NestedScreen,
      Prev.Result == ScreenPathResult<Prev.To>
{
    public typealias From = Prev.From
    public typealias To = T.To

    let keyPath: PartialKeyPath<T.From.PathFrom>
    let prev: Prev
    let transition: T
    let context: ContextStrategy
    let state: AnyScreenState?
    var _state: AnyScreenState? { state }

    enum ContextStrategy {
        case weak
        case strong(T.Context)
    }

    public subscript<T>(next path: KeyPath<To.PathFrom, T>) -> T { transition[next: path] }

    public func __move(from surface: Prev.From.Content, completion: (() -> Void)?) -> ScreenPathResult<T.To> {
        let (prevState, prevSurface) = prev.__move(from: surface, completion: nil)
        guard
            prevState === state,
            let next = prevState.next,
            next.keyPath == keyPath,
            let content = next.content.map({ $0 as! ContentResult<T.To> }),
            transition.hierarchyTest(from: prevSurface, to: content.screenContent)
        else {
            guard case .strong(let ctx) = context else { fatalError("The screen was not found in the hierarchy and cannot be created, because the context was not provided") }
            let (nextState, content) = transition.move(from: prevSurface, state: prevState as! ContentScreenState<T.From>, with: ctx, completion: completion)
            nextState.keyPath = keyPath
            nextState.surface = content.screenContent
            nextState.surfaceWrapper = content.contentWrapper
            prevState.next = nextState
            nextState.previous = prevState
            return (nextState, content.screenContent)
        }
        if case .strong(let ctx) = context {
            transition.updateContent(content.contentWrapper, context: ctx)
        }
        return (next, content.screenContent)
    }
    @discardableResult
    public func move(from surface: Prev.From.Content, completion: (() -> Void)?) -> ScreenPathResult<T.To> {
        // TODO: Unrelated states will not come back if transition does not perform this action
        state?.next?._backFurther(completion: nil)
        return __move(from: surface, completion: completion)
    }
}
extension NextPath {
    public func index(of keyPath: PartialKeyPath<To.PathFrom>) -> Int { transition.index(of: keyPath) }
    public func keyPath(at index: Int) -> PartialKeyPath<To.PathFrom> { transition.keyPath(at: index) }
}

extension ScreenPath {
    public subscript<U>(move path: KeyPath<To.PathFrom, U>, ctx: U.Context) -> NextPath<Self, U>
    where U: Transition, U.From == To.NestedScreen {
        NextPath<Self, U>(keyPath: path, prev: self, transition: self[next: path], context: .strong(ctx), state: (self as! ScreenPathPrivate)._state?.next)
    }
    public subscript<U>(move path: KeyPath<To.PathFrom, Optional<U>>, ctx: U.Context) -> NextPath<Self, U>?
    where U: Transition, U.From == To.NestedScreen {
        guard let transition = self[next: path] else { return nil }
        return NextPath<Self, U>(keyPath: path, prev: self, transition: transition, context: .strong(ctx), state: (self as! ScreenPathPrivate)._state?.next)
    }
    public subscript<U>(move path: KeyPath<To.PathFrom, U>) -> NextPath<Self, U>
    where U: Transition, U.From == To.NestedScreen {
        NextPath<Self, U>(keyPath: path, prev: self, transition: self[next: path], context: .weak, state: (self as! ScreenPathPrivate)._state?.next)
    }
    public subscript<U>(move path: KeyPath<To.PathFrom, Optional<U>>) -> NextPath<Self, U>?
    where U: Transition, U.From == To.NestedScreen {
        guard let transition = self[next: path] else { return nil }
        return NextPath<Self, U>(keyPath: path, prev: self, transition: transition, context: .weak, state: (self as! ScreenPathPrivate)._state?.next)
    }
}
extension ScreenPath {
    public func move<U>(_ path: KeyPath<To.PathFrom, U>, _ ctx: U.Context) -> NextPath<Self, U>
    where U: Transition, U.From == To.NestedScreen {
        NextPath<Self, U>(keyPath: path, prev: self, transition: self[next: path], context: .strong(ctx), state: (self as! ScreenPathPrivate)._state?.next)
    }
    public func move<U>(_ path: KeyPath<To.PathFrom, Optional<U>>, _ ctx: U.Context) -> NextPath<Self, U>?
    where U: Transition, U.From == To.NestedScreen {
        guard let transition = self[next: path] else { return nil }
        return NextPath<Self, U>(keyPath: path, prev: self, transition: transition, context: .strong(ctx), state: (self as! ScreenPathPrivate)._state?.next)
    }
}
