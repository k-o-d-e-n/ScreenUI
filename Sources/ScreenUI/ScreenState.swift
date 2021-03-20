//
//  ScreenState.swift
//  Pods
//
//  Created by Denis Koryttsev on 02.03.2021.
//

import Foundation
#if canImport(SwiftUI)
import SwiftUI
#endif

public class AnyScreenState {
    var keyPath: AnyKeyPath?
    weak var next: AnyScreenState?
    fileprivate weak var _weakPrevious: AnyScreenState?
    fileprivate var _strongPrevious: AnyScreenState?
    var previous: AnyScreenState? {
        set { _strongPrevious = newValue }
        get { _weakPrevious ?? _strongPrevious }
    }
    var content: Any? { nil }
    #if SCREENUI_BETA
    public var _isActive: Bool {
        set {
            guard let prev = previous, prev.next == nil || prev.next !== self else { return }
            if newValue {
                prev.next = self
            } else {
                prev.next = nil
            }
        }
        get { previous?.next === self }
    }
    #endif

    func back(completion: (() -> Void)?) {}
}

public class TransitionState<From, To>: ScreenState<To> where From: Screen, To: Screen {
    override var content: Any? {
        guard let surface = surface, let wrapper = surfaceWrapper else { return nil }
        return ContentResult<To>(wrapper, surface)
    }

    override var previous: AnyScreenState? {
        willSet {
            assert(newValue.map { $0 as? ContentScreenState<From.NestedScreen> != nil } ?? true, "Invalid type of the previous state")
        }
    }
    var previousState: ContentScreenState<From.NestedScreen>? {
        set { previous = newValue }
        get { previous.map { $0 as! ContentScreenState<From.NestedScreen> } }
    }

    override func back(completion: (() -> Void)?) {
        guard back == nil && isActive_SwiftUI == nil else {
            return super.back(completion: completion)
        }
        guard
            let prev = previousState,
            (keyPath as? PartialKeyPath<From.PathFrom>).flatMap({ prev.childStates[$0] }) === self
        else { return }
        prev.back(completion: completion)
    }
}

@propertyWrapper struct Surface<T> {
    private weak var _weakValue: AnyObject?
    private var _strongValue: T?
    var wrappedValue: T? {
        set {
            if T.self is AnyClass {
                _weakValue = newValue as AnyObject
            } else {
                /// _strongValue = newValue
            }
        }
        get { _strongValue ?? _weakValue.map { $0 as! T } }
    }
}
public class ScreenState<S>: ContentScreenState<S.NestedScreen> where S: Screen {
    @Surface var surfaceWrapper: S.Content?
    override var content: Any? { surfaceWrapper }
}
public class ContentScreenState<S>: AnyScreenState where S: ContentScreen {
    @Surface var surface: S.Content?
    override var content: Any? { surface }
    #if canImport(SwiftUI)
    var isActive_SwiftUI: _Binding<Bool>?
    var selectedIndex_SwiftUI: _Binding<Int>?
    #endif
    private(set) var childStates: [PartialKeyPath<S.PathFrom>: AnyScreenState] = [:]

    public override init() {}
    deinit {
        #if DEBUG
        if ProcessInfo.processInfo.arguments.contains("SCREENUI_DEBUGLOG_ON") {
            print("Deinitialized state \(self)")
        }
        #endif
    }

    public subscript<To>(child path: PartialKeyPath<S.PathFrom>, _ : To.Type) -> TransitionState<S, To>? {
        set {
            if let value = newValue {
                value._strongPrevious = nil
                value._weakPrevious = self
            }
            childStates[path] = newValue
        }
        get { childStates[path] as? TransitionState<S, To> }
    }
    #if SCREENUI_BETA
    public subscript(child path: PartialKeyPath<S.PathFrom>) -> AnyScreenState? {
        childStates[path]
    }
    #endif

    public var back: AnyBackTransition<S>?

    override func back(completion: (() -> Void)?) {
        #if canImport(SwiftUI)
        guard isActive_SwiftUI == nil else {
            isActive_SwiftUI!.wrappedValue = false
            if let compl = completion {
                DispatchQueue.main.async(execute: compl)
            }
            return
        }
        #endif
        guard let back = back, let s = surface else { return }
        back.move(from: s, completion: completion)
    }
}
@propertyWrapper struct _Binding<T> {
    let get: () -> T
    let set: (T) -> Void
    var wrappedValue: T { get { get() } nonmutating set { set(newValue) } }
}

extension Router {
    public func back(completion: (() -> Void)? = nil) {
        state.back(completion: completion)
    }
}

/// -----------

#if SCREENUI_BETA
final class _ProxyState<T>: ContentScreenState<T> where T: ContentScreen {
    let proxy: AnyScreenState
    init(proxy: AnyScreenState) {
        self.proxy = proxy
    }
    override var previous: AnyScreenState? {
        set { proxy.previous = newValue }
        get { proxy.previous }
    }
    override var next: AnyScreenState? {
        set { proxy.next = newValue }
        get { proxy.next }
    }
}
extension Router {
    public func _proxied<Root>(by root: Root) -> Router<Root.NestedScreen> where Root: Screen {
        Router<Root.NestedScreen>(from: root, state: _ProxyState(proxy: state))
    }
}
#endif
