//
//  AppKit.swift
//  Pods
//
//  Created by Denis Koryttsev on 02.03.2021.
//

import Foundation
#if os(macOS)
import AppKit

extension Win {
    public struct AppKit<Root>: ScreenContainer where Root: Screen, Root.Content: NSViewController {
        public typealias Content = NSWindow
        public typealias NestedScreen = Root.NestedScreen
        public typealias Context = Root.Context
        var root: Root

        let rect: NSRect
        let styleMask: NSWindow.StyleMask
        let backingStoreType: NSWindow.BackingStoreType
        let isDefer: Bool

        public init(
            rect: NSRect = NSRect(origin: .zero, size: CGSize(width: 500, height: 500)),
            styleMask style: NSWindow.StyleMask = [.resizable, .titled, .closable],
            backing backingStoreType: NSWindow.BackingStoreType = .buffered,
            defer flag: Bool = false,
            _ root: Root
        ) {
            self.rect = rect
            self.styleMask = style
            self.backingStoreType = backingStoreType
            self.isDefer = flag
            self.root = root
        }

        public subscript<T>(next path: KeyPath<Root.PathFrom, T>) -> T {
            root[next: path]
        }

        public func makeContent(_ context: Root.Context, router: Router<Root.NestedScreen>) -> ContentResult<Win.AppKit<Root>> {
            let window = NSWindow(contentRect: rect, styleMask: styleMask, backing: backingStoreType, defer: isDefer)
            let (content1, content0) = root.makeContent(context, router: router)
            window.contentViewController = content1
            return (window, content0)
        }
    }
}
extension Tab {
    public struct AppKit<Root>: ContentScreen where Root: ScreenBuilder, Root.Content == [NSViewController] {
        public typealias NestedScreen = Self
        public typealias Content = NSTabViewController
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
            let tabBarController = NSTabViewController()
            let c1 = root.makeContent(context, router: router)
            tabBarController.tabViewItems = c1.map(NSTabViewItem.init)
            observer.value = tabBarController.observe(\.selectedTabViewItemIndex, changeHandler: { (tbc, ch) in
                guard let state = router.state.childStates[router.keyPath(at: tbc.selectedTabViewItemIndex)] else { return }
                router.state.next = state
            })
            return (tabBarController, tabBarController)
        }
    }
    public struct AppKitTransition<From, Too>: Transition where From: Screen, Too: Screen, From.Content: NSTabViewController {
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
            screen.selectedTabViewItemIndex = index
            return (state[child: path, To.self]!, transform(screen.tabViewItems[index].viewController as! Too.Content))
        }
    }
}
extension Tab.AppKit {
    public init(@ContentBuilder tabs builder: () -> Root) {
        self.init(root: builder())
    }
}

extension Presentation {
    public struct AppKit<From, Too>: ScreenTransition
    where From: ContentScreen, Too: Screen, Too.Content: NSViewController,
          From.Content: NSViewController, Too.NestedScreen.Content: NSViewController
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
            nextState.back = .some(Presentation.Dismiss.AppKit(animated: animated))
            let (content1, content0) = to.makeContent(context, router: Router(from: to, state: nextState))
            CATransaction.begin()
            CATransaction.setCompletionBlock(completion)
            if !animated {
                CATransaction.setAnimationDuration(0)
            }
            surface.presentAsModalWindow(content1)
            CATransaction.commit()
            return (nextState, content0)
        }
    }
}
extension Presentation.Dismiss {
    public struct AppKit<From>: BackTransition
    where From: ContentScreen, From.Content: NSViewController {
        let animated: Bool

        public func move(from content: From.Content, completion: (() -> Void)?) {
            CATransaction.begin()
            CATransaction.setCompletionBlock(completion)
            if !animated {
                CATransaction.setAnimationDuration(0)
            }
            content.dismiss(nil)
            CATransaction.commit()
        }
    }
}

extension Screen where Content: NSViewController {
    public func present<From>(animated: Bool = true) -> AppKit.Present<From, Self> {
        Presentation.AppKit(self, animated: animated)
    }
}

extension Presentation.AppKit {
    public func index(of keyPath: PartialKeyPath<To.PathFrom>) -> Int { to.index(of: keyPath) }
    public func keyPath(at index: Int) -> PartialKeyPath<To.PathFrom> { to.keyPath(at: index) }
}
extension Tab.AppKit {
    public func index(of keyPath: PartialKeyPath<Root.PathFrom>) -> Int { root.index(of: keyPath) }
    public func keyPath(at index: Int) -> PartialKeyPath<Root.PathFrom> { root.keyPath(at: index) }
}
extension Win.AppKit {
    public func index(of keyPath: PartialKeyPath<Root.PathFrom>) -> Int { root.index(of: keyPath) }
    public func keyPath(at index: Int) -> PartialKeyPath<Root.PathFrom> { root.keyPath(at: index) }
}

extension Router where From.Content: NSTabViewController {
    public subscript<T>(select path: KeyPath<PathFrom, T>) -> StartPath<Tab.AppKitTransition<From, T>> where T: UnwrappedScreen {
        let screen = self[next: path]
        let transition = Tab.AppKitTransition<From, T>(index: index(of: path), path: path, to: screen, transform: T.nestedContent(from:))
        return StartPath<Tab.AppKitTransition<From, T>>(keyPath: path, transition: transition, context: (), state: state)
    }
}
extension ScreenPath where To.Content: NSTabViewController {
    public subscript<T>(select path: KeyPath<PathFrom, T>) -> NextPath<Self, Tab.AppKitTransition<To, T>> where T: UnwrappedScreen {
        let screen = self[next: path]
        let transition = Tab.AppKitTransition<To, T>(index: index(of: path), path: path, to: screen, transform: T.nestedContent(from:))
        return NextPath<Self, Tab.AppKitTransition<To, T>>(keyPath: path, prev: self, transition: transition, context: (), state: (self as! ScreenPathPrivate)._state?.next as? ScreenState<To.NestedScreen>)
    }
}
#endif
