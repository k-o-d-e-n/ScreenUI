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

public class __ContentScreenState: _ContentScreenState {
    weak var next: _ContentScreenState?
    var previous: _ContentScreenState?

    func corresponds<To>(_ context: Any, of type: To.Type) -> TransitionResult<To>? where To : Screen { nil }
    func back(completion: (() -> Void)?) {}
}

protocol _ContentScreenState: AnyObject {
    /// strong
    var previous: _ContentScreenState? { get set }
    /// weak
    var next: _ContentScreenState? { get set }

    func corresponds<To>(_ context: Any, of type: To.Type) -> TransitionResult<To>? where To : Screen
    func back(completion: (() -> Void)?)
}

/// -----------

protocol NextScreenState: _ContentScreenState {
    func back(completion: (() -> Void)?)
}

public class ScreenState<S>: __ContentScreenState, NextScreenState where S: ContentScreen {
    /// private var evaluator: AnyStateEvaluator<P.Content>?
    private weak var _weakSurface: AnyObject?
    private var _strongSurface: S.Content?
    var surface: S.Content? {
        set {
            if S.Content.self is AnyClass {
                _weakSurface = newValue as AnyObject
            } else {
                _strongSurface = newValue
            }
        }
        get {
            _strongSurface ?? (_weakSurface as? S.Content)
        }
    }
    override var next: _ContentScreenState? {
        didSet {
            next?.previous = self
        }
    }
    /// var isActive: Bool { false }
    #if canImport(SwiftUI)
    var isActive_SwiftUI: _Binding<Bool>?
    var selectedIndex_SwiftUI: _Binding<Int>?
    #endif
    var childStates: [PartialKeyPath<S.PathFrom>: __ContentScreenState] = [:]

    public override init() {
        /// self.point = point
    }

    public subscript<Screen>(child path: PartialKeyPath<S.PathFrom>, _ : Screen.Type) -> ScreenState<Screen>? {
        return childStates[path] as? ScreenState<Screen>
    }

    override func corresponds<To>(_ context: Any, of type: To.Type) -> TransitionResult<To>? where To : Screen {
        (surface as? To.NestedScreen.Content).flatMap({ s in (self as? ScreenState<To.NestedScreen>).map({ ($0, s) }) })
    }

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
        guard let s = surface else { return }
        back?.move(from: s, completion: completion)
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
