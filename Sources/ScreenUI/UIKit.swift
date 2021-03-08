//
//  UIKit.swift
//  Pods
//
//  Created by Denis Koryttsev on 02.03.2021.
//

import Foundation

#if !os(macOS)
import UIKit

extension Win {
    public struct UIKit<Root>: ScreenContainer where Root: Screen, Root.Content: UIViewController {
        public typealias NestedScreen = Root.NestedScreen
        public typealias Content = UIWindow

        public struct Context {
            public enum WindowScene {
                case `default`
                @available(iOS 13.0, *)
                case scene(UIWindowScene?)
            }

            public let scene: WindowScene
            public let root: Root.Context

            public init(scene: WindowScene = .default, root: Root.Context) {
                self.scene = scene
                self.root = root
            }
        }
        let _root: Root

        public init(_ root: Root) {
            self._root = root
        }

        public subscript<T>(next path: KeyPath<Root.PathFrom, T>) -> T {
            _root[next: path]
        }

        public func makeContent(_ context: Context, router: Router<Root.NestedScreen>) -> ContentResult<Win.UIKit<Root>> {
            let window: UIWindow
            switch context.scene {
            case .scene(.some(let scene)):
                if #available(iOS 13.0, *) {
                    window = UIWindow(windowScene: scene)
                } else {
                    window = UIWindow()
                }
            case .default, .scene(.none):
                window = UIWindow()
            }
            let (content1, content0) = _root.makeContent(context.root, router: router)
            window.rootViewController = content1
            return (window, content0)
        }
    }
}
extension Tab {
    public struct UIKit<Root>: ContentScreen where Root: ScreenBuilder, Root.Content == [UIViewController] {
        public typealias NestedScreen = Self
        public typealias Content = UITabBarController
        public typealias Context = Root.Context

        let root: Root

        public subscript<T>(next path: KeyPath<Root.PathFrom, T>) -> T {
            root[next: path]
        }

        final class TabsObserver {
            var value: NSKeyValueObservation?
        }
        let observer: TabsObserver = TabsObserver()

        public func makeContent(_ context: Context, router: Router<NestedScreen>) -> ContentResult<Self> {
            let tabBarController = UITabBarController()
            let c1 = root.makeContent(context, router: router)
            tabBarController.viewControllers = c1
            observer.value = tabBarController.observe(\.selectedViewController, changeHandler: { (tbc, ch) in
                guard let state = router.state.childStates[router.keyPath(at: tbc.selectedIndex)] else { return }
                router.state.next = state
            })
            return (tabBarController, tabBarController)
        }
    }
    public struct UIKitTransition<From, Too>: Transition where From: Screen, Too: Screen, From.Content: UITabBarController {
        public typealias To = Too.NestedScreen
        let index: Int
        let path: PartialKeyPath<From.PathFrom>
        let to: Too
        let transform: (Too.Content) -> To.Content

        public subscript<T>(next path: KeyPath<To.PathFrom, T>) -> T {
            to[next: path]
        }
        public func index(of keyPath: PartialKeyPath<To.PathFrom>) -> Int { to.index(of: keyPath) }
        public func keyPath(at index: Int) -> PartialKeyPath<To.PathFrom> { to.keyPath(at: index) }

        public func move(from screen: From.Content, state: ScreenState<From.NestedScreen>, with context: Void, completion: (() -> Void)?) -> TransitionResult<To> {
            screen.selectedIndex = index
            return (state[child: path, To.self]!, transform(screen.selectedViewController as! Too.Content))
        }
    }
}
extension Tab.UIKit {
    public init(@ContentBuilder tabs builder: () -> Root) {
        self.init(root: builder())
    }
}
extension Nav {
    public struct UIKit<Root>: ScreenContainer where Root: Screen, Root.Content: UIViewController {
        public typealias Context = Root.Context
        public typealias Content = UINavigationController
        public typealias NestedScreen = Root.NestedScreen
        let _root: Root

        public init(_ root: Root) {
            self._root = root
        }

        public subscript<T>(next path: KeyPath<Root.PathFrom, T>) -> T { _root[next: path] }

        public func makeContent(_ context: Root.Context, router: Router<Root.NestedScreen>) -> ContentResult<Nav.UIKit<Root>> {
            let (content1, content0) = _root.makeContent(context, router: router)
            let content2 = UINavigationController(rootViewController: content1)
            return (content2, content0)
        }
    }
}

extension Nav.Push {
    public struct UIKit<From, Too>: ScreenTransition
    where From: ContentScreen, Too: Screen, From.Content: UIViewController,
          Too.Content: UIViewController, Too.NestedScreen.Content: UIViewController
    {
        public typealias To = Too.NestedScreen
        let to: Too
        let animated: Bool

        public init(_ to: Too, animated: Bool = true) {
            self.to = to
            self.animated = animated
        }

        public subscript<T>(next path: KeyPath<To.PathFrom, T>) -> T {
            to[next: path]
        }

        public func move(from screen: From.Content, state: ScreenState<From.NestedScreen>, with context: Too.Context, completion: (() -> Void)?) -> TransitionResult<To> {
            let nextState = ScreenState<To>()
            nextState.back = .some(Pop.UIKit(animated: animated))
            let (content1, content0) = to.makeContent(context, router: Router(from: to, state: nextState))
            CATransaction.begin()
            CATransaction.setCompletionBlock(completion)
            screen.navigationController?.pushViewController(content1, animated: animated)
            CATransaction.commit()
            return (nextState, content0)
        }
    }
}
extension Nav.Push.Pop {
    public struct UIKit<From>: BackTransition
    where From: ContentScreen, From.Content: UIViewController
    {
        let animated: Bool

        public func move(from content: From.Content, completion: (() -> Void)?) {
            CATransaction.begin()
            CATransaction.setCompletionBlock(completion)
            content.navigationController?.popViewController(animated: animated)
            CATransaction.commit()
        }
    }
}

extension Presentation {
    public struct UIKit<From, Too>: ScreenTransition
    where From: ContentScreen, Too: Screen, Too.Content: UIViewController, Too.NestedScreen.Content: UIViewController,
          From.Content: UIViewController
    {
        public typealias To = Too.NestedScreen
        let to: Too
        let animated: Bool

        public init(_ to: Too, animated: Bool = true) {
            self.to = to
            self.animated = animated
        }

        public subscript<T>(next path: KeyPath<To.PathFrom, T>) -> T {
            to[next: path]
        }

        public func move(from surface: From.Content, state: ScreenState<From.NestedScreen>, with context: Too.Context, completion: (() -> Void)?) -> TransitionResult<To> {
            let nextState = ScreenState<To>()
            nextState.back = .some(Presentation.Dismiss.UIKit(animated: animated))
            let (content1, content0) = to.makeContent(context, router: Router(from: to, state: nextState))
            surface.present(content1, animated: animated, completion: completion)
            return (nextState, content0)
        }
    }
}
extension Presentation.Dismiss {
    public struct UIKit<From>: BackTransition
    where From: ContentScreen, From.Content: UIViewController {
        let animated: Bool

        public func move(from content: From.Content, completion: (() -> Void)?) {
            content.dismiss(animated: animated, completion: completion)
        }
    }
}

extension Screen where Content: UIViewController {
    public func navigation() -> UIKit.Navigation<Self> { Nav.UIKit(self) }
}
extension Screen where Content: UIViewController {
    public func push<From>(animated: Bool = true) -> UIKit.Push<From, Self> where From.Content: UIViewController {
        Nav.Push.UIKit(self, animated: animated)
    }
}
extension Screen where Content: UIViewController {
    public func present<From>(animated: Bool = true) -> UIKit.Present<From, Self> {
        Presentation.UIKit(self, animated: animated)
    }
}

extension Win.UIKit: UnwrappedScreen where Root: UnwrappedScreen {
    public static func nestedContent(from content: UIWindow) -> Root.NestedScreen.Content {
        Root.nestedContent(from: content.rootViewController as! Root.Content)
    }
}
extension Win.UIKit {
    public func index(of keyPath: PartialKeyPath<Root.PathFrom>) -> Int { _root.index(of: keyPath) }
    public func keyPath(at index: Int) -> PartialKeyPath<Root.PathFrom> { _root.keyPath(at: index) }
}
extension Tab.UIKit: UnwrappedScreen {}
extension Nav.UIKit: UnwrappedScreen where Root: UnwrappedScreen {
    public static func nestedContent(from content: UINavigationController) -> Root.NestedScreen.Content {
        Root.nestedContent(from: content.viewControllers[0] as! Root.Content)
    }
}
extension Nav.UIKit {
    public func index(of keyPath: PartialKeyPath<Root.PathFrom>) -> Int { _root.index(of: keyPath) }
    public func keyPath(at index: Int) -> PartialKeyPath<Root.PathFrom> { _root.keyPath(at: index) }
}
extension Nav.Push.UIKit {
    public func index(of keyPath: PartialKeyPath<To.PathFrom>) -> Int { to.index(of: keyPath) }
    public func keyPath(at index: Int) -> PartialKeyPath<To.PathFrom> { to.keyPath(at: index) }
}
extension Presentation.UIKit {
    public func index(of keyPath: PartialKeyPath<To.PathFrom>) -> Int { to.index(of: keyPath) }
    public func keyPath(at index: Int) -> PartialKeyPath<To.PathFrom> { to.keyPath(at: index) }
}
extension Tab.UIKit {
    public func index(of keyPath: PartialKeyPath<Root.PathFrom>) -> Int { root.index(of: keyPath) }
    public func keyPath(at index: Int) -> PartialKeyPath<Root.PathFrom> { root.keyPath(at: index) }
}

extension Router where From.Content: UITabBarController {
    public subscript<T>(select path: KeyPath<PathFrom, T>) -> StartPath<Tab.UIKitTransition<From, T>> where T: UnwrappedScreen {
        let screen = self[next: path]
        let transition = Tab.UIKitTransition<From, T>(index: index(of: path), path: path, to: screen, transform: T.nestedContent(from:))
        return StartPath<Tab.UIKitTransition<From, T>>(keyPath: path, transition: transition, context: (), state: state)
    }
}
extension ScreenPath where To.Content: UITabBarController {
    public subscript<T>(select path: KeyPath<PathFrom, T>) -> NextPath<Self, Tab.UIKitTransition<To, T>> where T: UnwrappedScreen {
        let screen = self[next: path]
        let transition = Tab.UIKitTransition<To, T>(index: index(of: path), path: path, to: screen, transform: T.nestedContent(from:))
        return NextPath<Self, Tab.UIKitTransition<To, T>>(keyPath: path, prev: self, transition: transition, context: (), state: (self as! ScreenPathPrivate)._state?.next as? ScreenState<To.NestedScreen>)
    }
}
#endif
