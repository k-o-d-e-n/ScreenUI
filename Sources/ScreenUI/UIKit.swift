//
//  UIKit.swift
//  Pods
//
//  Created by Denis Koryttsev on 02.03.2021.
//

import Foundation

#if !os(macOS) && !os(watchOS)
import UIKit

extension Win {
    public struct UIKit<Root>: ScreenContainer where Root: Screen, Root.Content: UIViewController {
        public typealias NestedScreen = Root.NestedScreen
        public typealias Content = UIWindow

        public struct Context {
            public enum WindowScene {
                case `default`
                @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
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

        public subscript<T>(next path: KeyPath<Root.PathFrom, T>) -> T { _root[next: path] }
        public func index(of keyPath: PartialKeyPath<Root.PathFrom>) -> Int { _root.index(of: keyPath) }
        public func keyPath(at index: Int) -> PartialKeyPath<Root.PathFrom> { _root.keyPath(at: index) }

        public func makeContent(_ context: Context, router: Router<Root.NestedScreen>) -> ContentResult<Win.UIKit<Root>> {
            let window: UIWindow
            switch context.scene {
            case .scene(.some(let scene)):
                if #available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *) {
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
        public func updateContent(_ content: Content, with context: Context) {
            _root.updateContent(content.rootViewController as! Root.Content, with: context.root)
        }
        public func updateNestedContent(_ content: Root.NestedScreen.Content, with context: Context) {
            _root.updateNestedContent(content, with: context.root)
        }
    }
}
extension Tab {
    public struct UIKit<Root>: ContentScreen where Root: ScreenBuilder, Root.Content == [UIViewController] {
        public typealias NestedScreen = Self
        public typealias Content = UITabBarController
        public typealias Context = Root.Context

        let root: Root

        public subscript<T>(next path: KeyPath<Root.PathFrom, T>) -> T { root[next: path] }
        public func index(of keyPath: PartialKeyPath<Root.PathFrom>) -> Int { root.index(of: keyPath) }
        public func keyPath(at index: Int) -> PartialKeyPath<Root.PathFrom> { root.keyPath(at: index) }

        public func makeContent(_ context: Context, router: Router<NestedScreen>) -> ContentResult<Self> {
            let tabBarController = UITabBarController()
            let c1 = root.makeContent(context, router: router)
            tabBarController.viewControllers = c1
            let observation = tabBarController.observe(\.selectedViewController, changeHandler: { (tbc, ch) in
                guard let state = router.state.childStates[router.keyPath(at: tbc.selectedIndex)] else { return }
                router.state.next = state
            })
            objc_setAssociatedObject(tabBarController, Unmanaged.passUnretained(tabBarController).toOpaque(), observation, .OBJC_ASSOCIATION_RETAIN)
            return (tabBarController, tabBarController)
        }
        public func updateContent(_ content: Content, with context: Root.Context) {
            root.updateContent(content.viewControllers ?? [], with: context)
        }
    }
    public struct UIKitTransition<Fromm, Too>: Transition where Fromm: Screen, Too: UnwrappedScreen, Fromm.NestedScreen.Content: UITabBarController {
        public typealias From = Fromm.NestedScreen
        public typealias To = Too
        let index: Int
        let path: PartialKeyPath<From.PathFrom>
        let to: Too

        public subscript<T>(next path: KeyPath<To.PathFrom, T>) -> T { to[next: path] }
        public func index(of keyPath: PartialKeyPath<To.PathFrom>) -> Int { to.index(of: keyPath) }
        public func keyPath(at index: Int) -> PartialKeyPath<To.PathFrom> { to.keyPath(at: index) }

        public func move(from screen: From.Content, state: ContentScreenState<From.NestedScreen>, with context: Void, completion: (() -> Void)?) -> TransitionResult<From, To> {
            screen.selectedIndex = index
            let c1 = screen.selectedViewController as! Too.Content
            let c0 = Too.nestedContent(from: c1)
            return (state[child: path, Too.self]!, (c1, c0))
        }
        public func hierarchyTest(from fromContent: From.Content, to toContent: Too.NestedScreen.Content) -> Bool {
            guard fromContent.selectedIndex == index else { return false } /// checks already through key-path
            guard fromContent.selectedViewController is Too.Content else { return false } /// conditional screens is not responsive to external changes that breaks previous configuration
            return true/// Too.nestedContent(from: tooContent) === toContent
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
        public func index(of keyPath: PartialKeyPath<Root.PathFrom>) -> Int { _root.index(of: keyPath) }
        public func keyPath(at index: Int) -> PartialKeyPath<Root.PathFrom> { _root.keyPath(at: index) }

        public func makeContent(_ context: Root.Context, router: Router<Root.NestedScreen>) -> ContentResult<Nav.UIKit<Root>> {
            let (content1, content0) = _root.makeContent(context, router: router)
            let content2 = UINavigationController(rootViewController: content1)
            return (content2, content0)
        }
        public func updateContent(_ content: Content, with context: Root.Context) {
            _root.updateContent(content.viewControllers[0] as! Root.Content, with: context)
        }
        public func updateNestedContent(_ content: Root.NestedScreen.Content, with context: Root.Context) {
            _root.updateNestedContent(content, with: context)
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

        public subscript<T>(next path: KeyPath<To.PathFrom, T>) -> T { to[next: path] }
        public func index(of keyPath: PartialKeyPath<To.PathFrom>) -> Int { to.index(of: keyPath) }
        public func keyPath(at index: Int) -> PartialKeyPath<To.PathFrom> { to.keyPath(at: index) }

        public func move(from screen: From.Content, state: ContentScreenState<From.NestedScreen>, with context: Too.Context, completion: (() -> Void)?) -> TransitionResult<From, To> {
            let nextState = TransitionState<From, To>()
            nextState.back = .some(Pop.UIKit(animated: animated))
            let (content1, content0) = to.makeContent(context, router: Router(from: to, state: nextState))
            Self.resolve(screen) {
                CATransaction.begin()
                CATransaction.setCompletionBlock(completion)
                screen.navigationController?.pushViewController(content1, animated: animated) // TODO: If `screen` not topViewController it will be incorrect behavior.
                CATransaction.commit()
            }
            return (nextState, (content0, content0))
        }

        public func updateContent(_ content: To.Content, context: Too.Context) {
            to.updateNestedContent(content, with: context)
        }

        public func hierarchyTest(from fromContent: From.Content, to toContent: Too.NestedScreen.Content) -> Bool {
            guard let navigation = toContent.navigationController else { return false }
            return navigation == fromContent.navigationController
        }

        static func resolve(_ content: From.Content, completion: @escaping () -> Void) {
            #if SCREENUI_BETA
            guard let navigation = content.navigationController else { return completion() }
            guard let presented = navigation.presentedViewController else { return completion() }
            presented.dismiss(animated: false, completion: completion) // TODO: dismiss need to call on navigation, else presented.presented removed only
            #else
            completion()
            #endif
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
        let style: Style
        let animated: Bool

        public enum Style {
            case `default`
            case system(UIModalTransitionStyle?, UIModalPresentationStyle?)
            case custom(UIViewControllerTransitioningDelegate)
        }

        public init(
            _ to: Too,
            style: Style = .default,
            animated: Bool = true
        ) {
            self.to = to
            self.style = style
            self.animated = animated
        }

        public subscript<T>(next path: KeyPath<To.PathFrom, T>) -> T { to[next: path] }
        public func index(of keyPath: PartialKeyPath<To.PathFrom>) -> Int { to.index(of: keyPath) }
        public func keyPath(at index: Int) -> PartialKeyPath<To.PathFrom> { to.keyPath(at: index) }

        public func move(from surface: From.Content, state: ContentScreenState<From.NestedScreen>, with context: Too.Context, completion: (() -> Void)?) -> TransitionResult<From, To> {
            let nextState = TransitionState<From, To>()
            nextState.back = .some(Presentation.Dismiss.UIKit(animated: animated))
            let (content1, content0) = to.makeContent(context, router: Router(from: to, state: nextState))
            switch style {
            case .custom(let delegate):
                content1.modalPresentationStyle = .custom
                content1.transitioningDelegate = delegate
            case .system(let modalTransitionStyle, let modalPresentationStyle):
                if let style = modalTransitionStyle {
                    content1.modalTransitionStyle = style
                }
                if let style = modalPresentationStyle {
                    content1.modalPresentationStyle = style
                }
            case .default: break
            }
            Self.resolve(surface) {
                surface.present(content1, animated: animated, completion: completion)
            }
            return (nextState, (content0, content0))
        }

        public func updateContent(_ content: To.Content, context: Too.Context) {
            to.updateNestedContent(content, with: context)
        }

        public func hierarchyTest(from fromContent: From.Content, to toContent: Too.NestedScreen.Content) -> Bool {
            guard let presentingViewController = toContent.presentingViewController else { return false }
            return fromContent.presentedViewController?.presentingViewController === presentingViewController
        }

        static func resolve(_ content: From.Content, completion: @escaping () -> Void) {
            guard content.viewIfLoaded?.window == nil else {
                #if SCREENUI_BETA
                guard content.presentedViewController != nil else { return completion() }
                return content.dismiss(animated: false, completion: completion)
                #else
                return completion()
                #endif
            }
            guard #available(iOS 10.0, tvOS 10.0, *) else { return completion() }
            var fireTimes = 0
            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { (timer) in
                if content.viewIfLoaded?.window != nil || fireTimes >= 10 {
                    timer.invalidate()
                    completion()
                }
                fireTimes += 1
            }
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
    public func present<From>(
        style: Presentation.UIKit<From, Self>.Style = .default, animated: Bool = true
    ) -> UIKit.Present<From, Self> {
        Presentation.UIKit(self, style: style, animated: animated)
    }
}

extension Win.UIKit: UnwrappedScreen where Root: UnwrappedScreen {
    public static func nestedContent(from content: UIWindow) -> Root.NestedScreen.Content {
        Root.nestedContent(from: content.rootViewController as! Root.Content)
    }
}
extension Tab.UIKit: UnwrappedScreen {}
extension Nav.UIKit: UnwrappedScreen where Root: UnwrappedScreen {
    public static func nestedContent(from content: UINavigationController) -> Root.NestedScreen.Content {
        Root.nestedContent(from: content.viewControllers[0] as! Root.Content)
    }
}

extension Router where From.NestedScreen.Content: UITabBarController {
    public subscript<T>(select path: KeyPath<PathFrom, T>) -> StartPath<Tab.UIKitTransition<From.NestedScreen, T>> where T: UnwrappedScreen {
        let screen = self[next: path]
        let transition = Tab.UIKitTransition<From.NestedScreen, T>(index: index(of: path), path: path, to: screen)
        return StartPath<Tab.UIKitTransition<From.NestedScreen, T>>(keyPath: path, transition: transition, context: .strong(()), state: state)
    }
}
extension ScreenPath where To.NestedScreen.Content: UITabBarController {
    public subscript<T>(select path: KeyPath<PathFrom, T>) -> NextPath<Self, Tab.UIKitTransition<To.NestedScreen, T>> where T: UnwrappedScreen {
        let screen = self[next: path]
        let transition = Tab.UIKitTransition<To.NestedScreen, T>(index: index(of: path), path: path, to: screen)
        return NextPath<Self, Tab.UIKitTransition<To.NestedScreen, T>>(keyPath: path, prev: self, transition: transition, context: .strong(()), state: (self as! ScreenPathPrivate)._state?.next as? ContentScreenState<To.NestedScreen>)
    }
}
#endif
