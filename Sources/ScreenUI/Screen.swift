
#if canImport(SwiftUI)
import SwiftUI
#endif

public struct Router<From>: PathProvider where From: ContentScreen {
    let from: _PathFrom<From.PathFrom>
    let state: ScreenState<From.NestedScreen>

    init<S: Screen>(from: S, state: ScreenState<From.NestedScreen>) where S.PathFrom == From.PathFrom {
        self.from = __PathFrom(base: from)
        self.state = state
    }

    public subscript<T>(next path: KeyPath<From.PathFrom, T>) -> T {
        from[next: path]
    }
    public func index(of keyPath: PartialKeyPath<From.PathFrom>) -> Int {
        from.index(of: keyPath)
    }
    public func keyPath(at index: Int) -> PartialKeyPath<From.PathFrom> {
        from.keyPath(at: index)
    }

    public func next<Next>(from next: Next, isActive: Bool = true) -> Router<Next.NestedScreen>
    where Next: Screen {
        let nextState = ScreenState<Next.NestedScreen>()
        nextState.previous = state
        if isActive {
            state.next = nextState
        }
        return Router<Next.NestedScreen>(from: next, state: nextState)
    }
    public func next<T, Next>(from next: Next, path: KeyPath<From.PathFrom, T>, isActive: Bool)
    -> Router<Next.NestedScreen>
    where Next: Screen, T: Transition, T.To == Next.NestedScreen {
        let router = self.next(from: next, isActive: isActive)
        state.childStates[path] = router.state
        return router
    }
    public func next<Next>(from next: Next, path: KeyPath<From.PathFrom, Next>, isActive: Bool)
    -> Router<Next.NestedScreen>
    where Next: Screen {
        let router = self.next(from: next, isActive: isActive)
        state.childStates[path] = router.state
        return router
    }

    public static func root<Root>(from: Root) -> Router<From>
    where Root: /*Root*/Screen, From.PathFrom == Root.PathFrom {
        Router(from: from, state: ScreenState<From.NestedScreen>())
    }
    public static func router<Next>(from next: Next, with state: ScreenState<From.NestedScreen>) -> Router<From>
    where Next: Screen, Next.PathFrom == From.PathFrom {
        Router(from: next, state: state)
    }
}
extension Router {
    public func move<T>(_ path: KeyPath<From.PathFrom, T>, from fromContent: T.From.Content, with context: T.Context, completion: (() -> Void)? = nil) where T: Transition, T.From == From {
        let (nextState, content) = from[next: path].move(from: fromContent, state: state, with: context, completion: completion)
        nextState.surface = content
        nextState.previous = state
        state.next = nextState
    }
    public func move<T>(_ path: KeyPath<From.PathFrom, Optional<T>>, from fromContent: T.From.Content, with context: T.Context, completion: (() -> Void)? = nil) where T: Transition, T.From == From {
        guard let transition = from[next: path] else { return }
        let (nextState, content) = transition.move(from: fromContent, state: state, with: context, completion: completion)
        nextState.surface = content
        nextState.previous = state
        state.next = nextState
    }
    public func _move<T>(_ path: KeyPath<From.PathFrom, T>, with context: T.Context, completion: (() -> Void)? = nil) where T: Transition, T.From == From.NestedScreen {
        let (nextState, content) = from[next: path].move(from: state.surface!, state: state, with: context, completion: completion)
        nextState.surface = content
        nextState.previous = state
        state.next = nextState
    }
    public func _move<T>(_ path: KeyPath<From.PathFrom, Optional<T>>, with context: T.Context, completion: (() -> Void)? = nil) where T: Transition, T.From == From.NestedScreen {
        guard let transition = from[next: path] else { return }
        let (nextState, content) = transition.move(from: state.surface!, state: state, with: context, completion: completion)
        nextState.surface = content
        nextState.previous = state
        state.next = nextState
    }
}

/// ------------

public typealias ContentResult<S> = (contentWrapper: S.Content, screenContent: S.NestedScreen.Content) where S: Screen
public protocol Screen: PathProvider where PathFrom == NestedScreen.PathFrom {
    associatedtype NestedScreen: ContentScreen where NestedScreen.NestedScreen == NestedScreen
    associatedtype Content
    associatedtype Context
    func makeContent(_ context: Context, router: Router<NestedScreen>) -> ContentResult<Self>
}
/// where ContentScreen == Self
public protocol ContentScreen: Screen, UnwrappedScreen {}
public protocol ScreenContainer: Screen {}

extension Screen where Content == Self, NestedScreen == Self {
    public func makeContent(_ context: Context, router: Router<NestedScreen>) -> ContentResult<Self> {
        (self, self)
    }
}

/// -----------

/// - Conditional screens
///
///     struct SomeScreen: ConditionalScreen {}
///     struct SwitchTransition: ScreenTransition {}
///
///     extension ScreenPath where To: ConditionalScreen {
///         subscript<T>(case path: KeyPath<To.PathFrom, T>, context: T.Context) -> NextPath<Self, SwitchTransition<To, T>>
///     }
///

public protocol ConditionalScreen: ContentScreen {}
extension ScreenPath where To: ConditionalScreen {
    public func _nextPath<T, S>(_ transition: T, at path: KeyPath<To.PathFrom, S>, context: T.Context) -> NextPath<Self, T> where S: Screen, T.From == To {
        NextPath<Self, T>(keyPath: path, prev: self, transition: transition, context: context, state: (self as? ScreenPathPrivate)?._state?.next as? ScreenState<To.NestedScreen>)
    }
}
extension RootRouter where From.Root: ConditionalScreen {
    public func _startPath<T, S>(_ transition: T, at path: KeyPath<From.Root.PathFrom, S>, context: T.Context) -> StartPath<T> where S: Screen, T.From == From.Root, T.To == S.NestedScreen {
        StartPath<T>(keyPath: path, transition: transition, context: context, state: state.next as! ScreenState<From.Root.NestedScreen>)
    }
}

/// -----------

public struct RootRouter<From>: PathProvider where From: RootScreen {
    let from: _PathFrom<From.PathFrom>
    let state: ScreenState<From.NestedScreen>

    init<S: Screen>(from: S, state: ScreenState<From.NestedScreen>) where S.PathFrom == From.PathFrom {
        self.from = __PathFrom(base: from)
        self.state = state
    }
    public subscript<T>(next path: KeyPath<From.PathFrom, T>) -> T {
        from[next: path]
    }
    public func index(of keyPath: PartialKeyPath<From.PathFrom>) -> Int {
        from.index(of: keyPath)
    }
    public func keyPath(at index: Int) -> PartialKeyPath<From.PathFrom> {
        from.keyPath(at: index)
    }
}
public protocol RootScreen: ContentScreen where Context == Root.Context, Content == Void, NestedScreen == Self, PathFrom == Self {
    associatedtype Root: Screen
    var state: ScreenState<Self> { get }
    var root: Root { get }
}
extension RootScreen {
    public var router: RootRouter<Self> { RootRouter(from: self, state: state) }
    public func makeContent(_ context: Context, router: Router<NestedScreen>) -> ContentResult<Self> {
        ((), ())
    }
}
public struct RootTransition<From>: Transition where From: RootScreen {
    public typealias To = From.Root.NestedScreen
    let to: From.Root
    public subscript<T>(next path: KeyPath<To.PathFrom, T>) -> T {
        to[next: path]
    }
    public func index(of keyPath: PartialKeyPath<To.PathFrom>) -> Int { to.index(of: keyPath) }
    public func keyPath(at index: Int) -> PartialKeyPath<To.PathFrom> { to.keyPath(at: index) }
    public func move(from screen: From.Content, state: ScreenState<From.NestedScreen>, with context: From.Root.Context, completion: (() -> Void)?) -> TransitionResult<To> {
        let nextState = ScreenState<To>()
        let (_, c0) = to.makeContent(context, router: Router(from: to, state: nextState))
        nextState.previous = state
        state.next = nextState
        return (nextState, c0)
    }
}
extension RootRouter {
    public subscript(root context: From.Root.Context) -> StartPath<RootTransition<From>> {
        let transition = RootTransition<From>(to: from[next: \.root])
        return StartPath<RootTransition<From>>(keyPath: \From.root, transition: transition, context: context, state: state)
    }
}

public struct AppScreen<Root>: RootScreen where Root: Screen {
    public typealias Content = Void
    public typealias Context = Root.Context
    public typealias NestedScreen = Self
    public let state: ScreenState<Self> = ScreenState()
    public let root: Root
    public init(_ root: Root) {
        self.root = root
    }
}

/// -----------

public protocol UnwrappedScreen: Screen {
    static func nestedContent(from content: Content) -> NestedScreen.Content
}
extension Screen where NestedScreen == Self {
    public static func nestedContent(from content: Content) -> NestedScreen.Content { content }
}

/// -----------

class _AnyScreen_<Nested, Context, Content> where Nested: ContentScreen, Nested.NestedScreen == Nested {
    typealias _Context = Context
    typealias _Content = Content
    typealias _Nested = Nested
    subscript<T>(next path: KeyPath<Nested.PathFrom, T>) -> T { fatalError() }
    func index(of keyPath: PartialKeyPath<Nested.PathFrom>) -> Int { fatalError() }
    func keyPath(at index: Int) -> PartialKeyPath<Nested.PathFrom> { fatalError() }

    func makeContent(_ context: _Context, router: Router<_Nested>) -> (contentWrapper: _Content, screenContent: _Nested.Content) {
        fatalError("unimplemented")
    }
}
final class __AnyScreen_<S>: _AnyScreen_<S.NestedScreen, S.Context, S.Content>, Screen where S: Screen {
    typealias Content = S.Content
    typealias Context = S.Context
    typealias NestedScreen = S.NestedScreen
    let base: S
    init(base: S) {
        self.base = base
    }

    override subscript<T>(next path: KeyPath<S.PathFrom, T>) -> T { base[next: path] }
    override func index(of keyPath: PartialKeyPath<S.PathFrom>) -> Int { base.index(of: keyPath) }
    override func keyPath(at index: Int) -> PartialKeyPath<S.PathFrom> { base.keyPath(at: index) }

    override func makeContent(_ context: S.Context, router: Router<S.NestedScreen>) -> ContentResult<__AnyScreen_<S>> {
        base.makeContent(context, router: router)
    }
}
public struct _NestedScreen<Nested, Content>: Screen where Nested: ContentScreen {
    public typealias NestedScreen = Nested.NestedScreen
    public typealias Context = Nested.Context
    public typealias Content = Content

    let base: _AnyScreen_<Nested.NestedScreen, Context, Content>
    public init<Base>(_ base: Base) where Base: Screen, Base.Content == Content, Base.Context == Context, Base.NestedScreen == Nested.NestedScreen {
        self.base = __AnyScreen_<Base>(base: base)
    }

    public subscript<T>(next path: KeyPath<Nested.PathFrom, T>) -> T {
        base[next: path]
    }

    public func makeContent(_ context: Context, router: Router<Nested.NestedScreen>) -> ContentResult<Self> {
        base.makeContent(context, router: router)
    }
}
extension _NestedScreen {
    public func index(of keyPath: PartialKeyPath<Nested.PathFrom>) -> Int { base.index(of: keyPath) }
    public func keyPath(at index: Int) -> PartialKeyPath<Nested.PathFrom> { base.keyPath(at: index) }
}
public struct _AnyScreen<Nested, Context, Content>: Screen where Nested: ContentScreen {
    public typealias NestedScreen = Nested.NestedScreen
    public typealias Context = Context
    public typealias Content = Content

    let base: _AnyScreen_<Nested.NestedScreen, Context, Content>
    public init<Base>(_ base: Base) where Base: Screen, Base.Content == Content, Base.Context == Context, Base.NestedScreen == Nested.NestedScreen {
        self.base = __AnyScreen_<Base>(base: base)
    }

    public subscript<T>(next path: KeyPath<Nested.PathFrom, T>) -> T {
        base[next: path]
    }

    public func makeContent(_ context: Context, router: Router<Nested.NestedScreen>) -> ContentResult<Self> {
        base.makeContent(context, router: router)
    }
}
extension _AnyScreen {
    public func index(of keyPath: PartialKeyPath<Nested.PathFrom>) -> Int { base.index(of: keyPath) }
    public func keyPath(at index: Int) -> PartialKeyPath<Nested.PathFrom> { base.keyPath(at: index) }
}

/// ------------

public struct NeverScreen: ContentScreen {
    public typealias NestedScreen = Self
    public typealias Content = Never
    public func makeContent(_ context: Never, router: Router<Self>) -> ContentResult<Self> {}
}
public struct UnavailableContentScreen<Content>: ContentScreen {
    public typealias NestedScreen = Self
    public typealias Content = Content
    public init() {}
    public func makeContent(_ context: Never, router: Router<Self>) -> ContentResult<Self> {}
}
public struct UnavailableScreen<Content, NestedContent>: Screen {
    public typealias NestedScreen = UnavailableContentScreen<NestedContent>
    public typealias Content = Content
    public typealias Context = Never
    public subscript<T>(next path: KeyPath<NestedScreen.PathFrom, T>) -> T { fatalError("unavailable") }
    public func makeContent(_ context: Never, router: Router<UnavailableContentScreen<NestedContent>>) -> ContentResult<UnavailableScreen<Content, NestedContent>> {}
}
public struct UnavailableScreen2<Content, Nested>: Screen where Nested: ContentScreen, Nested.NestedScreen == Nested {
    public typealias NestedScreen = Nested
    public typealias Content = Content
    public subscript<T>(next path: KeyPath<NestedScreen.PathFrom, T>) -> T { fatalError("unavailable") }
    public func makeContent(_ context: Never, router: Router<Nested>) -> ContentResult<UnavailableScreen2<Content, Nested>> {}
}

/// ------------

public struct MapContent<Base, NewContent>: Screen where Base: Screen {
    public typealias NestedScreen = Base.NestedScreen
    public typealias Context = Base.Context
    public typealias Content = NewContent
    let base: Base
    let transform: (Base.Content, Base.Context, Base) -> NewContent

    public subscript<T>(next path: KeyPath<Base.PathFrom, T>) -> T {
        base[next: path]
    }

    public func makeContent(_ context: Base.Context, router: Router<Base.NestedScreen>) -> ContentResult<MapContent<Base, NewContent>> {
        let (c1, c0) = base.makeContent(context, router: router)
        return (transform(c1, context, base), c0)
    }
}
extension MapContent {
    public func index(of keyPath: PartialKeyPath<Base.PathFrom>) -> Int { base.index(of: keyPath) }
    public func keyPath(at index: Int) -> PartialKeyPath<Base.PathFrom> { base.keyPath(at: index) }
}
extension Screen {
    public func mapContent<NewContent>(_ transform: @escaping (Content) -> NewContent) -> MapContent<Self, NewContent> {
        MapContent(base: self, transform: { c, _, _ in transform(c) })
    }
    public func mapContent<NewContent>(_ transform: @escaping (Content, Context, Self) -> NewContent) -> MapContent<Self, NewContent> {
        MapContent(base: self, transform: transform)
    }
    public func configContent(_ config: @escaping (Content, Context, Self) -> Void) -> MapContent<Self, Content> {
        MapContent(base: self, transform: { config($0, $1, $2); return $0 })
    }
    public func configContent(_ config: @escaping (Content) -> Void) -> MapContent<Self, Content> {
        MapContent(base: self, transform: { c, _, _ in config(c); return c })
    }
}
public struct ClosedContext<Base>: Screen where Base: Screen {
    public typealias NestedScreen = Base.NestedScreen
    public typealias Content = Base.Content
    public typealias Context = Void
    fileprivate let base: Base
    fileprivate let context: Base.Context
    public subscript<T>(next path: KeyPath<Base.PathFrom, T>) -> T { base[next: path] }
    public func index(of keyPath: PartialKeyPath<Base.PathFrom>) -> Int { base.index(of: keyPath) }
    public func keyPath(at index: Int) -> PartialKeyPath<Base.PathFrom> { base.keyPath(at: index) }
    public func makeContent(_ context: Context, router: Router<Base.NestedScreen>) -> ContentResult<ClosedContext<Base>> {
        base.makeContent(self.context, router: router)
    }
}
extension Screen {
    public func with(_ context: Context) -> ClosedContext<Self> {
        ClosedContext(base: self, context: context)
    }
}
