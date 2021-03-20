//
//  SwiftUI.swift
//  Pods
//
//  Created by Denis Koryttsev on 02.03.2021.
//

import Foundation

#if canImport(SwiftUI) && canImport(Combine)
import SwiftUI
import Combine

public protocol SwiftUICompatibleTransition: Transition {
    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
    func move<V>(_ state: Binding<Bool>, screenState: ContentScreenState<To.NestedScreen>, actionView: V, context: Context, completion: (() -> Void)?) -> AnyView where V: View
}

extension Win {
    @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
    public struct SwiftUI<Root>: ScreenContainer where Root: Screen, Root.Content: View {
        let _root: Root

        public init(_ root: Root) {
            self._root = root
        }

        public subscript<T>(next path: KeyPath<Root.PathFrom, T>) -> T { _root[next: path] }
        public func index(of keyPath: PartialKeyPath<Root.PathFrom>) -> Int { _root.index(of: keyPath) }
        public func keyPath(at index: Int) -> PartialKeyPath<Root.PathFrom> { _root.keyPath(at: index) }

        public typealias Content = WindowGroup<Root.Content>
        public typealias Context = Root.Context
        public typealias NestedScreen = Root.NestedScreen
        public func makeContent(_ context: Root.Context, router: Router<Root.NestedScreen>) -> ContentResult<Win.SwiftUI<Root>> {
            let (content1, content0) = _root.makeContent(context, router: router)
            return (WindowGroup { content1 }, content0)
        }
    }
}

public protocol _TabsViewIdentity {}
extension Tab {
    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 7.0, *)
    public struct SwiftUI<Root>: ContentScreen where Root: ScreenBuilder {
        public typealias NestedScreen = Self
        public typealias Content = TabsView
        public typealias Context = Root.Context

        let root: Root

        public subscript<T>(next path: KeyPath<Root.PathFrom, T>) -> T { root[next: path] }
        public func index(of keyPath: PartialKeyPath<Root.PathFrom>) -> Int { root.index(of: keyPath) }
        public func keyPath(at index: Int) -> PartialKeyPath<Root.PathFrom> { root.keyPath(at: index) }

        public func makeContent(_ context: Context, router: Router<NestedScreen>) -> ContentResult<Self> {
            let tabs = TabsView(router: router, content: root.makeContent(context, router: router), selectedIndex: 0)
            return (tabs, tabs)
        }

        public struct TabsView: View, _TabsViewIdentity {
            let router: Router<NestedScreen>
            let content: Root.Content

            @State var selectedIndex: Int
            public var body: some View {
                let _selected = _selectedIndex
                let _binding = _Binding(
                    get: { _selected.wrappedValue },
                    set: { newValue in
                        _selected.wrappedValue = newValue
                        guard let state = router.state.childStates[router.keyPath(at: newValue)] else { return }
                        router.state.next = state
                    }
                )
                router.state.selectedIndex_SwiftUI = _binding
                let binding = Binding(get: _binding.get, set: _binding.set)
                return TabView(selection: binding) {
                    TupleView(content)
                }
            }
        }
    }
    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
    public struct SwiftUITransition<From, Too>: SwiftUICompatibleTransition where From: Screen, Too: Screen, From.Content: _TabsViewIdentity {
        public typealias To = Too
        let to: Too
        public subscript<T>(next path: KeyPath<To.PathFrom, T>) -> T { to[next: path] }
        public func index(of keyPath: PartialKeyPath<To.PathFrom>) -> Int { to.index(of: keyPath) }
        public func keyPath(at index: Int) -> PartialKeyPath<To.PathFrom> { to.keyPath(at: index) }
        public func move(from screen: From.Content, state: ContentScreenState<From.NestedScreen>, with context: Void, completion: (() -> Void)?) -> TransitionResult<From, To> {
            fatalError("unavailable")
        }
        public func move<V>(_ state: Binding<Bool>, screenState: ContentScreenState<Too.NestedScreen>, actionView: V, context: (), completion: (() -> Void)?) -> AnyView where V : View {
            fatalError("unavailable")
        }
    }
}
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 7.0, *)
extension Tab.SwiftUI {
    public init(@ContentBuilder tabs builder: () -> Root) {
        self.init(root: builder())
    }
}
extension Nav {
    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 7.0, *)
    public struct SwiftUI<Root>: ScreenContainer where Root: Screen, Root.Content: View {
        public typealias Context = Root.Context
        public typealias Content = NavigationView<Root.Content>
        public typealias NestedScreen = Root.NestedScreen
        let _root: Root

        public init(_ root: Root) {
            self._root = root
        }

        public subscript<T>(next path: KeyPath<Root.PathFrom, T>) -> T { _root[next: path] }
        public func index(of keyPath: PartialKeyPath<Root.PathFrom>) -> Int { _root.index(of: keyPath) }
        public func keyPath(at index: Int) -> PartialKeyPath<Root.PathFrom> { _root.keyPath(at: index) }

        public func makeContent(_ context: Root.Context, router: Router<Root.NestedScreen>) -> ContentResult<Nav.SwiftUI<Root>> {
            let (content1, content0) = _root.makeContent(context, router: router)
            return (NavigationView { content1 }, content0)
        }
    }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Nav.Push {
    public struct SwiftUI<From, Too>: SwiftUICompatibleTransition where From: ContentScreen, Too: Screen, Too.Content: View {
        public typealias To = Too.NestedScreen
        let to: Too

        #if !os(macOS)
        let isDetail: Bool
        public init(_ to: Too, isDetail: Bool = true) {
            self.to = to
            self.isDetail = isDetail
        }
        #else
        public init(_ to: Too) {
            self.to = to
        }
        #endif

        public subscript<T>(next path: KeyPath<To.PathFrom, T>) -> T { to[next: path] }
        public func index(of keyPath: PartialKeyPath<To.PathFrom>) -> Int { to.index(of: keyPath) }
        public func keyPath(at index: Int) -> PartialKeyPath<To.PathFrom> { to.keyPath(at: index) }

        public func move(from surface: From.Content, state: ContentScreenState<From.NestedScreen>, with context: Too.Context, completion: (() -> Void)?) -> TransitionResult<From, To> {
            let state = TransitionState<From, To>()
            let (_, c0) = to.makeContent(context, router: Router(from: to, state: state))
            return (state, (c0, c0))
        }
        public func move<V>(_ state: Binding<Bool>, screenState: ContentScreenState<Too.NestedScreen>, actionView: V, context: Too.Context, completion: (() -> Void)?) -> AnyView where V : View {
            let link = NavigationLink(
                destination: to.makeContent(context, router: Router(from: to, state: screenState)).contentWrapper
                    .onAppear(perform: completion),
                isActive: state.projectedValue,
                label: { actionView }
            )
            #if os(iOS)
            return AnyView(link.isDetailLink(isDetail))
            #else
            return AnyView(link)
            #endif
        }
    }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Presentation {
    public struct SwiftUI<From, Too>: SwiftUICompatibleTransition where From: ContentScreen, Too: Screen, Too.Content: View {
        public typealias To = Too.NestedScreen
        let to: Too
        public init(_ to: Too) {
            self.to = to
        }

        public subscript<T>(next path: KeyPath<To.PathFrom, T>) -> T { to[next: path] }
        public func index(of keyPath: PartialKeyPath<To.PathFrom>) -> Int { to.index(of: keyPath) }
        public func keyPath(at index: Int) -> PartialKeyPath<To.PathFrom> { to.keyPath(at: index) }

        public func move(from surface: From.Content, state: ContentScreenState<From.NestedScreen>, with context: Too.Context, completion: (() -> Void)?) -> TransitionResult<From, To> {
            let state = TransitionState<From, To>()
            let (_, c0) = to.makeContent(context, router: Router(from: to, state: state))
            return (state, (c0, c0))
        }
        public func move<V>(_ state: Binding<Bool>, screenState: ContentScreenState<Too.NestedScreen>, actionView: V, context: Too.Context, completion: (() -> Void)?) -> AnyView where V : View {
            AnyView(actionView.sheet(isPresented: state) {
                to.makeContent(context, router: Router(from: to, state: screenState)).contentWrapper
                    .onAppear(perform: completion)
            })
        }
    }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 7.0, *)
extension Screen where Content: View {
    public func navigation() -> SwiftUI.Navigation<Self> { Nav.SwiftUI(self) }
}
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 7.0, *)
extension Screen where Content: View {
    public func push<From>() -> SwiftUI.Push<From, Self> {
        Nav.Push.SwiftUI(self)
    }
}
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 7.0, *)
extension Screen where Content: View {
    public func present<From>() -> SwiftUI.Present<From, Self> {
        Presentation.SwiftUI(self)
    }
}

extension Router {
    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
    public func move<T, ActionView>(_ path: KeyPath<From.PathFrom, T>, context: T.Context, action view: @escaping (Binding<Bool>) -> ActionView, completion: (() -> Void)?)
    -> some View where T: SwiftUICompatibleTransition, From == T.From, ActionView: View {
        let nextState = TransitionState<T.From.NestedScreen, T.To.NestedScreen>()
        nextState.previous = state
        state[child: path, T.To.NestedScreen.self] = nextState // replaced previous line
        return TransitionView<T, ActionView>(from[next: path], prevState: state, nextState: nextState, context: context, actionView: view, completion: completion)
    }
    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
    public func move<T, ActionView>(_ path: KeyPath<From.PathFrom, Optional<T>>, context: T.Context, action view: @escaping (Binding<Bool>) -> ActionView, completion: (() -> Void)?)
    -> TransitionView<T, ActionView>? where T: SwiftUICompatibleTransition, From == T.From, ActionView: View {
        guard let transition = from[next: path] else { return nil }
        let nextState = TransitionState<T.From.NestedScreen, T.To.NestedScreen>()
        nextState.previous = state
        state[child: path, T.To.NestedScreen.self] = nextState // replaced previous line
        return TransitionView<T, ActionView>(transition, prevState: state, nextState: nextState, context: context, actionView: view, completion: completion)
    }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct TransitionView<Transition, ActionView>: View where Transition: SwiftUICompatibleTransition, ActionView: View {
    let context: Transition.Context
    let transition: Transition
    let actionView: (Binding<Bool>) -> ActionView
    let completion: (() -> Void)?
    let prevState: ContentScreenState<Transition.From.NestedScreen>
    let state: ContentScreenState<Transition.To.NestedScreen>

    init(_ transition: Transition, prevState: ContentScreenState<Transition.From.NestedScreen>,
         nextState: ContentScreenState<Transition.To.NestedScreen>, context: Transition.Context,
         @ViewBuilder actionView: @escaping (Binding<Bool>) -> ActionView, completion: (() -> Void)?) {
        self.transition = transition
        self.context = context
        self.actionView = actionView
        self.completion = completion
        self.prevState = prevState
        self.state = nextState
    }

    @State var isActive: Bool = false
    public var body: some View {
        let _active = _isActive
        let _binding = _Binding(
            get: { _active.wrappedValue },
            set: { [weak state, weak prevState] newValue in
                _active.wrappedValue = newValue
                prevState?.next = newValue ? state : nil
            }
        )
        state.isActive_SwiftUI = _binding
        let binding = Binding(get: _binding.get, set: _binding.set)
        return transition.move(binding, screenState: state, actionView: actionView(binding), context: context, completion: completion)
            .onDisappear { [weak state] in
                state?.previous = nil
            }
    }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public protocol ScreenPath_SwiftUI: PathProvider where PathFrom == T.PathFrom {
    associatedtype T: SwiftUICompatibleTransition
    func __move() -> AnyPublisher<ContentScreenState<T.To.NestedScreen>?, Never>?
}
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct StartPath_SwiftUI<T>: ScreenPath, ScreenPathPrivate, ScreenPath_SwiftUI where T: SwiftUICompatibleTransition {
    public typealias From = UnavailableContentScreen<Void>
    public typealias To = T.To

    let change: Change
    let keyPath: PartialKeyPath<T.From.PathFrom>
    let transition: T
    let state: ContentScreenState<T.From.NestedScreen>?
    var _state: AnyScreenState? { state }

    enum Change {
        case isActive
        case selectedIndex(Int)
    }

    public subscript<T>(next path: KeyPath<To.PathFrom, T>) -> T { transition[next: path] }
    public func index(of keyPath: PartialKeyPath<To.PathFrom>) -> Int { transition.index(of: keyPath) }
    public func keyPath(at index: Int) -> PartialKeyPath<To.PathFrom> { transition.keyPath(at: index) }

    public func __move() -> AnyPublisher<ContentScreenState<T.To.NestedScreen>?, Never>? {
        guard let _state = state?[child: keyPath, T.To.self] else { return nil }
        switch change {
        case .isActive:
            guard let swiftUI_state = _state.isActive_SwiftUI else { return nil }
            swiftUI_state.wrappedValue = true
        case .selectedIndex(let index):
            state?.selectedIndex_SwiftUI?.wrappedValue = index
        }

        return Future { promise in
            DispatchQueue.main.async {
                promise(.success(_state))
            }
        }.eraseToAnyPublisher()
    }
    public func move(from surface: From.Content, completion: (() -> Void)?) -> Void {
        state?.next?._backFurther(completion: nil)
        var cancellable: AnyCancellable?
        cancellable = __move()?.sink(receiveValue: { (state) in
            cancellable?.cancel()
            cancellable = nil
            completion?()
        })
    }
}
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct NextPath_SwiftUI<Prev, T>: ScreenPath, ScreenPathPrivate, ScreenPath_SwiftUI
where Prev: ScreenPath & ScreenPath_SwiftUI, T: SwiftUICompatibleTransition, Prev.To.NestedScreen == T.From
{
    public typealias From = Prev.From
    public typealias To = T.To

    let change: Change
    let keyPath: PartialKeyPath<Prev.T.PathFrom>
    let prev: Prev
    let transition: T
    let state: ContentScreenState<T.From.NestedScreen>?
    var _state: AnyScreenState? { state }

    enum Change {
        case isActive
        case selectedIndex(Int)
    }

    public subscript<T>(next path: KeyPath<To.PathFrom, T>) -> T { transition[next: path] }
    public func index(of keyPath: PartialKeyPath<To.PathFrom>) -> Int { transition.index(of: keyPath) }
    public func keyPath(at index: Int) -> PartialKeyPath<To.PathFrom> { transition.keyPath(at: index) }

    public func __move() -> AnyPublisher<ContentScreenState<T.To.NestedScreen>?, Never>? {
        guard let prevFuture = prev.__move() else { return nil }
        return prevFuture.flatMap { (prevState) -> Future<ContentScreenState<T.To.NestedScreen>?, Never> in
            guard let _state = prevState?[child: keyPath, T.To.self]
            else { return Future { $0(.success(nil)) } }
            switch change {
            case .isActive:
                guard let swiftUI_state = _state.isActive_SwiftUI else { return Future { $0(.success(nil)) } }
                swiftUI_state.wrappedValue = true
            case .selectedIndex(let index):
                prevState?.selectedIndex_SwiftUI?.wrappedValue = index
            }
            return Future { promise in
                DispatchQueue.main.async {
                    promise(.success(_state))
                }
            }
        }.eraseToAnyPublisher()
    }
    public func move(from surface: Prev.From.Content, completion: (() -> Void)?) -> Void {
        state?.next?._backFurther(completion: nil)
        var cancellable: AnyCancellable?
        cancellable = __move()?.sink(receiveValue: { (state) in
            cancellable?.cancel()
            cancellable = nil
            completion?()
        })
    }
}
extension Router {
    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
    public subscript<T>(move path: KeyPath<PathFrom, T>) -> StartPath_SwiftUI<T> where T: SwiftUICompatibleTransition, T.From == From, T.To.Content: View {
        StartPath_SwiftUI<T>(change: .isActive, keyPath: path, transition: self[next: path], state: state)
    }
    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
    public subscript<T>(move path: KeyPath<PathFrom, Optional<T>>) -> StartPath_SwiftUI<T>? where T: SwiftUICompatibleTransition, T.From == From, T.To.Content: View {
        guard let transition = self[next: path] else { return nil }
        return StartPath_SwiftUI<T>(change: .isActive, keyPath: path, transition: transition, state: state)
    }
}
extension ScreenPath {
    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
    public subscript<U>(move path: KeyPath<To.PathFrom, U>) -> NextPath_SwiftUI<Self, U>
    where U: SwiftUICompatibleTransition, U.To.Content: View {
        let next = NextPath_SwiftUI<Self, U>(change: .isActive, keyPath: path, prev: self, transition: self[next: path], state: (self as! ScreenPathPrivate)._state?.next as? ContentScreenState<U.From.NestedScreen>)
        return next
    }
    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
    public subscript<U>(move path: KeyPath<To.PathFrom, Optional<U>>) -> NextPath_SwiftUI<Self, U>?
    where U: SwiftUICompatibleTransition, U.To.Content: View {
        guard let transition = self[next: path] else { return nil }
        return NextPath_SwiftUI<Self, U>(change: .isActive, keyPath: path, prev: self, transition: transition, state: (self as! ScreenPathPrivate)._state?.next as? ContentScreenState<U.From.NestedScreen>)
    }
}

extension Router where From.Content: _TabsViewIdentity {
    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
    public subscript<T>(select path: KeyPath<PathFrom, T>) -> StartPath_SwiftUI<Tab.SwiftUITransition<From, T>> {
        let screen = self[next: path]
        let transition = Tab.SwiftUITransition<From, T>(to: screen)
        return StartPath_SwiftUI<Tab.SwiftUITransition<From, T>>(change: .selectedIndex(index(of: path)), keyPath: path, transition: transition, state: state)
    }
}
extension ScreenPath where To.Content: _TabsViewIdentity {
    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
    public subscript<T>(select path: KeyPath<PathFrom, T>) -> NextPath_SwiftUI<Self, Tab.SwiftUITransition<To, T>> {
        let screen = self[next: path]
        let transition = Tab.SwiftUITransition<To, T>(to: screen)
        return NextPath_SwiftUI<Self, Tab.SwiftUITransition<To, T>>(change: .selectedIndex(index(of: path)), keyPath: path, prev: self, transition: transition, state: (self as! ScreenPathPrivate)._state?.next as? ContentScreenState<To>)
    }
}

/// ------------

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension RootTransition: SwiftUICompatibleTransition where From.Root.Content: View {
    public func move<V>(_ state: Binding<Bool>, screenState: ContentScreenState<From.Root.NestedScreen>, actionView: V, context: From.Context, completion: (() -> Void)?) -> AnyView where V : View {
        AnyView(to.makeContent(context, router: Router(from: to, state: screenState)).contentWrapper)
    }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension RootRouter where From.Root.Content: View {
    public subscript<T>(move path: KeyPath<From.Root.PathFrom, T>) -> StartPath_SwiftUI<T> where T: SwiftUICompatibleTransition, T.From == From.Root {
        StartPath_SwiftUI<T>(change: .isActive, keyPath: path, transition: from[next: \.root][next: path], state: state.next as? ContentScreenState<From.Root.NestedScreen>)
    }
}
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension RootRouter where From.Root.Content: Scene {
    public subscript<T>(move path: KeyPath<From.Root.PathFrom, T>) -> StartPath_SwiftUI<T> where T: SwiftUICompatibleTransition, T.From == From.Root {
        StartPath_SwiftUI<T>(change: .isActive, keyPath: path, transition: from[next: \.root][next: path], state: state.next as? ContentScreenState<From.Root.NestedScreen>)
    }
}
extension RootRouter where From.Root.NestedScreen.Content: _TabsViewIdentity {
    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
    public subscript<S>(select path: KeyPath<From.Root.PathFrom, S>) -> StartPath_SwiftUI<Tab.SwiftUITransition<From.Root.NestedScreen, S>> {
        let root = from[next: \.root]
        let transition = Tab.SwiftUITransition<From.Root.NestedScreen, S>(to: root[next: path])
        return StartPath_SwiftUI<Tab.SwiftUITransition<From.Root.NestedScreen, S>>(change: .selectedIndex(root.index(of: path)), keyPath: path, transition: transition, state: state.next as? ContentScreenState<From.Root.NestedScreen>)
    }
}
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension RootScreen where Root.Content: Scene {
    public func makeBody(_ context: Root.Context) -> some Scene {
        let nextState = TransitionState<Self, Root>()
        nextState.previous = state
        state.next = nextState
        return root.makeContent(context, router: Router(from: root, state: nextState)).contentWrapper
    }
}

#endif
