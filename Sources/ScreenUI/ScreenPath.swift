//
//  ScreenPath.swift
//  Pods
//
//  Created by Denis Koryttsev on 02.03.2021.
//

import Foundation

protocol ScreenPathPrivate {
    var _state: _ContentScreenState? { get }
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
extension _ContentScreenState {
    func _backFurther(completion: (() -> Void)?) {
        var topState: _ContentScreenState? = self
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

public struct StartPath<T>: ScreenPath, ScreenPathPrivate, ScreenPathPrivate2 where T: Transition {
    public typealias From = T.From
    public typealias To = T.To

    let keyPath: PartialKeyPath<T.From.PathFrom>
    let transition: T
    let context: T.Context
    let state: ScreenState<T.From.NestedScreen>
    var _state: _ContentScreenState? { state }

    public subscript<T>(next path: KeyPath<To.PathFrom, T>) -> T {
        transition[next: path]
    }

    public func __move(from surface: T.From.Content, completion: (() -> Void)?) -> TransitionResult<T.To> {
        guard let cached = state.next?.corresponds(context, of: T.To.self) else {
            let (nextState, content) = transition.move(from: surface, state: state, with: context, completion: completion)
            nextState.surface = content
            nextState.previous = _state
            state.next = nextState
            return (nextState, content)
        }
        return cached
    }
    @discardableResult
    public func move(from surface: T.From.Content, completion: (() -> Void)?) -> TransitionResult<T.To> {
        _state?.next?._backFurther(completion: nil)
        return __move(from: surface, completion: completion)
    }
}
extension StartPath {
    public func index(of keyPath: PartialKeyPath<To.PathFrom>) -> Int { transition.index(of: keyPath) }
    public func keyPath(at index: Int) -> PartialKeyPath<To.PathFrom> { transition.keyPath(at: index) }
}
extension Router {
    public subscript<T>(move path: KeyPath<PathFrom, T>, ctx: T.Context) -> StartPath<T> where T: Transition, T.From == From {
        StartPath<T>(keyPath: path, transition: self[next: path], context: ctx, state: state)
    }
    public subscript<T>(move path: KeyPath<PathFrom, Optional<T>>, ctx: T.Context) -> StartPath<T>? where T: Transition, T.From == From {
        guard let transition = self[next: path] else { return nil }
        return StartPath<T>(keyPath: path, transition: transition, context: ctx, state: state)
    }
}
public struct NextPath<Prev, T>: ScreenPath, ScreenPathPrivate, ScreenPathPrivate2
where Prev: ScreenPath & ScreenPathPrivate2, T: Transition, T.From == Prev.To.NestedScreen,
      Prev.Result == TransitionResult<Prev.To>
{
    public typealias From = Prev.From
    public typealias To = T.To

    let keyPath: PartialKeyPath<T.From.PathFrom>
    let prev: Prev
    let transition: T
    let context: T.Context
    let state: ScreenState<T.From.NestedScreen>?
    var _state: _ContentScreenState? { state }

    public subscript<T>(next path: KeyPath<To.PathFrom, T>) -> T {
        transition[next: path]
    }

    public func __move(from surface: Prev.From.Content, completion: (() -> Void)?) -> TransitionResult<T.To> {
        let (prevState, prevSurface) = prev.__move(from: surface, completion: nil)
        guard prevState === state, let cached = state?.next?.corresponds(context, of: T.To.self) else {
            let (nextState, content) = transition.move(from: prevSurface, state: prevState, with: context, completion: completion)
            nextState.surface = content
            prevState.next = nextState
            nextState.previous = prevState
            return (nextState, content)
        }
        return cached
    }
    @discardableResult
    public func move(from surface: Prev.From.Content, completion: (() -> Void)?) -> TransitionResult<T.To> {
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
    where U: Transition, U.From == To {
        // TODO: Unrelated states will not come back
        NextPath<Self, U>(keyPath: path, prev: self, transition: self[next: path], context: ctx, state: (self as! ScreenPathPrivate)._state?.next as? ScreenState<U.From.NestedScreen>)
    }
    public subscript<U>(move path: KeyPath<To.PathFrom, Optional<U>>, ctx: U.Context) -> NextPath<Self, U>?
    where U: Transition, U.From == To {
        guard let transition = self[next: path] else { return nil }
        return NextPath<Self, U>(keyPath: path, prev: self, transition: transition, context: ctx, state: (self as! ScreenPathPrivate)._state?.next as? ScreenState<U.From.NestedScreen>)
    }
}
