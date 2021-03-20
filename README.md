# 📲 ScreenUI

A multi-platform, multi-paradigm routing framework for iOS/macOS and others, the replacement of Storyboard.

Supports `UIKit`, `AppKit`, `SwiftUI`.

### Real world example

```swift
    static let transitionsMap = AppScreen(
        Delegate(
            ConditionalWindow {
                Launch()
                Welcome(
                    login: Present(Navigation(Login())),
                    registration: Present(Navigation(Registration()))
                )
                Tabs {
                    Navigation(
                        Feed(
                            page: Push(Page()),
                            match: Push(Match()),
                            gameDay: Push(GameDay(match: Push(Match()))),
                            tournament: Push(Tournament(match: Push(Match())))
                        )
                    )
                    Navigation(
                        Search(
                            filter: AnySearchFilter()
                                .navigation()
                                .configContent({ $0.isToolbarHidden = false })
                                .present(),
                            user: Present(Navigation(Player(team: Push(Team())))),
                            team: Team(player: Player().push())
                                .navigation()
                                .present(),
                            league: Present(Navigation(League())),
                            match: Present(Navigation(Match()))
                        )
                    )
                    Navigation(
                        Dashboard(
                            edit: Flow(base: UserEdit(editable: true)).present(),
                            entities: .init(
                                user: Push(Player(team: Team().navigation().present())),
                                team: Push(Team(player: Player().navigation().present())),
                                league: Push(League(
                                    team: Push(Team()),
                                    tournament: Push(Tournament(match: Push(Match())))
                                ))
                            )
                        )
                    )
                    Navigation(
                        Messages(
                            settings: Present(
                                Settings(
                                    account: Push(AccountInfo()),
                                    changePassword: Push(ChangePassword())
                                ).navigation()
                            )
                        )
                    )
                }
                .configContent({ tabbar in
                    tabbar.prepareViewAppearance()
                })
                .with(((), (), (), ()))
            }
        )
    )
```

## Table of contents

+ [**Main features**](#main-features)
+ [**Quick course**](#quick-course)
+ [**Deep dive**](#deep-dive)
  + [Screen](#screen)
  + [Transition](#transition)
  + [Screen path](#screen-path)
  + [Content builders](#content-builders)
  + [Cross-platform](#cross-platform)
  + [SwiftUI](#swiftui)
  + [UIKit](#uikit)
  + [AppKit](#appkit)
+ [**Installation**](#installation)

## Main features

+ Complete view of your app’s flow in one place
+ Isolating of screen transitions
+ Deep transitions (deep-link)
+ Abstracted implementation of the transition and its unification
+ Screen constants
+ Cross-platform core
+ Fully strong-typed code

With `ScreenUI` you will forget about such methods, like `func pushViewController(_:)`,  `func present(_:)`, about implementations are based on enums and reducers.

## Quick course

Just like in Storyboard, the framework works in terms of screens.

```swift
struct SomeScreen: ContentScreen {
    typealias NestedScreen = Self
    typealias Context = Void
    typealias Content = SomeView
    
    /// define constants (color, title, and so on)
    /// define transitions

    func makeContent(_ context: Context, router: Router<NestedScreen>) -> ContentResult<Self> {
        /// initialize a content view
        /// pass `context` and `router` to content (constants will be available through `router`)
        /// return the result
    }
}
```

Typical screen content implementation:

```swift
class SomeView {
    let router: Router<SomeScreen>
    let context: SomeScreen.Context
    let title: String

    init(router: Router<SomeScreen>, context: SomeScreen.Context) {
        self.router = router
        self.context = context
        self.title = router[next: \.title]
    }

    func didLoad() {
        let textLabel = TextLabel(title: context.text)
        ...
    }

    func closeScreen() {
        router.back(completion: nil)
    }
    
    func moveNext() {
        let nextScreenContext = ...
        router.move(\.nextScreen, from: self, with: nextScreenContext, completion: nil)
    }
}

```

All you need in the next step is to build a [screen tree](#real-world-example) and show any screen from hierarchy:

```swift
transitionsMap.router[root: .default][case: \.0, ()].move(from: (), completion: nil)
```

> Due to the specific interface of **SwiftUI** some things have small changes in API. 

## Deep dive

### Screen

Every screen must implement the protocol below:

```swift
public typealias ContentResult<S> = (contentWrapper: S.Content, screenContent: S.NestedScreen.Content) where S: Screen
public protocol Screen: PathProvider where PathFrom == NestedScreen.PathFrom {
    /// Routing target
    associatedtype NestedScreen: ContentScreen where NestedScreen.NestedScreen == NestedScreen
    /// *UIViewController* subclass in UIKit, *NSViewController* subclass in AppKit, *View* in SwiftUI, or your custom screen representer
    associatedtype Content
    /// Required data that is passed to content
    associatedtype Context = Void
    func makeContent(_ context: Context, router: Router<NestedScreen>) -> ContentResult<Self>
}
```

Screens that are responsible for performing transitions must implement the protocol `ContentScreen`.

Screen containers (like *Navigation*) must implement the protocol `ScreenContainer` where `ScreenContainer.NestedScreen` is a transition target.

```swift
public struct Navigation<Root>: ScreenContainer where Root: Screen, Root.Content: UIViewController {
    public typealias Context = Root.Context
    public typealias Content = UINavigationController
    public typealias NestedScreen = Root.NestedScreen
    let _root: Root

    public func makeContent(_ context: Root.Context, router: Router<Root.NestedScreen>) -> ContentResult<Self> {
        let (content1, content0) = _root.makeContent(context, router: router)
        let content2 = UINavigationController(rootViewController: content1)
        return (content2, content0)
    }
}
```

> [Read more]() about screens.

### Transition

Any transition must implement the protocol below:

```swift
public typealias TransitionResult<From, To> = (state: TransitionState<From, To>, screenContent: To.NestedScreen.Content) where From: Screen, To: Screen
public protocol Transition: PathProvider where PathFrom == To.PathFrom {
    associatedtype From: Screen
    associatedtype To: Screen
    associatedtype Context

    func move(from screen: From.Content, state: ScreenState<From.NestedScreen>, with context: Context, completion: (() -> Void)?) -> TransitionResult<From, To>
}
```

Transitions between the content screens must implement `ScreenTransition` protocol. Every such transition should provide a back behavior by assign `ScreenState.back` property.

```swift
public struct Present<From, To>: ScreenTransition {
    /// ...
    public func move(from content: From.Content, state: ScreenState<From.NestedScreen>, with context: Too.Context, completion: (() -> Void)?) -> TransitionResult<From, To> {
        let nextState = TransitionState<From, To>()
        nextState.back = .some(Dismiss(animated: animated))
        let (content1, content0) = to.makeContent(context, router: Router(from: to, state: nextState))
        surface.present(content1, animated: animated, completion: completion)
        return (nextState, (content1, content0))
    }
}
```

To make your screens more flexible, you can define type-erased transitions:
- `AnyScreenTransition` - supports transitions where `Context` is equal to *context* of the target content screen.
- `PreciseTransition` - supports transitions where `Context` is equal to *context* of the target container screen.

So, when you will building [screen tree](#real-world-example), you can set up in one scenario one transition, another transition in the another scenario for the same screen.

> [Read more]() about transitions.

### Screen path

`Router` provides a subscript interface to build the path to the screen using  *Swift Key-path expressions*:

```swift
///    [Initial screen]         [Conditional screen]      [Tab screen]     [Some next screen in scenario]    [Run chain from root screen content]
///       /                             |                       |            /                                  /
router[root: <%context%>][case: \.2, <%context%>][select: \.1][move: \.nextScreen, <%context%>].move(from: (), completion: nil)
```

### Content builders

Some screens can have dynamic content, for example `Tabs`. Therefore the framework provides `ScreenBuilder` protocol:

```swift
public protocol ScreenBuilder: PathProvider {
    associatedtype Content
    associatedtype Context

    func makeContent<From>(_ context: Context, router: Router<From>) -> Content where From: Screen, From.PathFrom == PathFrom
}
```

And of course for such instances is necessary Swift's function builder:

```swift
@_functionBuilder
public struct ContentBuilder {}
```

### Cross-platform

Framework API has cross-platform namespaces:

```swift
public enum Win {} /// Window implementations
public enum Nav {} /// Navigation implementations
public enum Tab {} /// Tabs implementations
extension Nav {
    public enum Push { /// Push implementations
        public enum Pop {} /// Pop implementations
    }
}
public enum Presentation { /// Present implementations
    public enum Dismiss {} /// Dismiss implementations
}
```

For convenience, the framework provides protocols that enable typealiases to the nested types: `UIKitNamespace`, `AppKitNamespace`, `SwiftUINamespace`.
Apply one of them and you can write crossplatform code where:

**Screens:**

- `Window` - a screen container that wraps a initial screen of your app.
- `Navigation` - a screen container that creates navigation stack.
- `Tabs` - a content screen that organize multiple screens to tab view interface.

**Transitions**

- `Push` - a transition that pushes a new screen onto the navigation stack, with the corresponding `Pop` transition.
- `Present` - a transition that presents a new screen, covering the current screen, with the corresponding `Dismiss` transition.

### SwiftUI

**Supported screens:**
- :white_check_mark: `Window`
- :white_check_mark: `Navigation`
- :white_check_mark: `Tabs`

**Supported transitions:**
- :white_check_mark: `Push`/`Pop`
- :white_check_mark: `Present`/`Dismiss`

### UIKit

**Supported screens:**
- :white_check_mark: `Window`
- :white_check_mark: `Navigation`
- :white_check_mark: `Tabs`

**Supported transitions:**
- :white_check_mark: `Push`/`Pop`
- :white_check_mark: `Present`/`Dismiss`

### AppKit

**Supported screens:**
- :white_check_mark: `Window`
- :white_check_mark: `Tabs`

**Supported transitions:**
- :white_check_mark: `Present`/`Dismiss`

## Installation

```ruby
pod 'ScreenUI'
```

## Author

Denis Koryttsev, @k-o-d-e-n, koden.u8800@gmail.com

## License

ScreenUI is available under the MIT license. See the LICENSE file for more info.
