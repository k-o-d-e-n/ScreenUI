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

        public subscript<T>(next path: KeyPath<Root.PathFrom, T>) -> T { root[next: path] }
        public func index(of keyPath: PartialKeyPath<Root.PathFrom>) -> Int { root.index(of: keyPath) }
        public func keyPath(at index: Int) -> PartialKeyPath<Root.PathFrom> { root.keyPath(at: index) }

        public func makeContent(_ context: Root.Context, router: Router<Root.NestedScreen>) -> ContentResult<Win.AppKit<Root>> {
            let window = NSWindow(contentRect: rect, styleMask: styleMask, backing: backingStoreType, defer: isDefer)
            let (content1, content0) = root.makeContent(context, router: router)
            window.contentViewController = content1
            return (window, content0)
        }
        public func updateContent(_ content: Content, with context: Context) {
            root.updateContent(content.contentViewController as! Root.Content, with: context)
        }
        public func updateNestedContent(_ content: Root.NestedScreen.Content, with context: Root.Context) {
            root.updateNestedContent(content, with: context)
        }
    }
}
extension Tab {
    public struct AppKit<Root>: ContentScreen where Root: ScreenBuilder, Root.Content == [NSViewController] {
        public typealias NestedScreen = Self
        public typealias Content = NSTabViewController
        public typealias Context = Root.Context

        let root: Root

        public subscript<T>(next path: KeyPath<Root.PathFrom, T>) -> T { root[next: path] }
        public func index(of keyPath: PartialKeyPath<Root.PathFrom>) -> Int { root.index(of: keyPath) }
        public func keyPath(at index: Int) -> PartialKeyPath<Root.PathFrom> { root.keyPath(at: index) }

        public func makeContent(_ context: Context, router: Router<NestedScreen>) -> ContentResult<Self> {
            let tabBarController = NSTabViewController()
            let c1 = root.makeContent(context, router: router)
            tabBarController.tabViewItems = c1.map(NSTabViewItem.init)
            let observation = tabBarController.observe(\.selectedTabViewItemIndex, changeHandler: { (tbc, ch) in
                guard let state = router.state.childStates[router.keyPath(at: tbc.selectedTabViewItemIndex)] else { return }
                router.state.next = state
            })
            objc_setAssociatedObject(tabBarController, Unmanaged.passUnretained(tabBarController).toOpaque(), observation, .OBJC_ASSOCIATION_RETAIN)
            return (tabBarController, tabBarController)
        }
        public func updateContent(_ content: Content, with context: Context) {
            root.updateContent(content.tabViewItems.compactMap(\.viewController), with: context)
        }
    }
    public struct AppKitTransition<Fromm, Too>: Transition where Fromm: Screen, Too: UnwrappedScreen, Fromm.NestedScreen.Content: NSTabViewController {
        public typealias To = Too
        public typealias From = Fromm.NestedScreen
        let index: Int
        let path: PartialKeyPath<From.PathFrom>
        let to: Too

        public subscript<T>(next path: KeyPath<To.PathFrom, T>) -> T { to[next: path] }
        public func index(of keyPath: PartialKeyPath<To.PathFrom>) -> Int { to.index(of: keyPath) }
        public func keyPath(at index: Int) -> PartialKeyPath<To.PathFrom> { to.keyPath(at: index) }

        public func move(from screen: From.Content, state: ContentScreenState<From.NestedScreen>, with context: Void, completion: (() -> Void)?) -> TransitionResult<From, To> {
            screen.selectedTabViewItemIndex = index
            let c1 = screen.tabViewItems[index].viewController as! Too.Content
            let c0 = Too.nestedContent(from: c1)
            return (state[child: path, Too.self]!, (c1, c0))
        }

        public func hierarchyTest(from fromContent: From.Content, to toContent: Too.NestedScreen.Content) -> Bool {
            guard fromContent.selectedTabViewItemIndex == index else { return false }
            guard fromContent.tabViewItems[index].viewController is Too.Content else { return false }
            return true
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
        let style: Style
        let animated: Bool

        public enum Style {
            case modal
            case sheet
            case popover(NSRect, PartialKeyPath<From.Content>, NSRectEdge, NSPopover.Behavior)
            case custom(NSViewControllerPresentationAnimator)
        }

        public init(_ to: Too, style: Style = .modal, animated: Bool = true) {
            self.to = to
            self.style = style
            self.animated = animated
        }

        public subscript<T>(next path: KeyPath<To.PathFrom, T>) -> T { to[next: path] }
        public func index(of keyPath: PartialKeyPath<To.PathFrom>) -> Int { to.index(of: keyPath) }
        public func keyPath(at index: Int) -> PartialKeyPath<To.PathFrom> { to.keyPath(at: index) }

        public func move(from surface: From.Content, state: ContentScreenState<From.NestedScreen>, with context: Too.Context, completion: (() -> Void)?) -> TransitionResult<From, To> {
            let nextState = TransitionState<From, To>()
            nextState.back = .some(Presentation.Dismiss.AppKit(animated: animated))
            let (content1, content0) = to.makeContent(context, router: Router(from: to, state: nextState))
            CATransaction.begin()
            CATransaction.setCompletionBlock(completion)
            if !animated {
                CATransaction.setAnimationDuration(0)
            }
            switch style {
            case .modal: surface.presentAsModalWindow(content1)
            case .sheet: surface.presentAsSheet(content1)
            case .popover(let rect, let viewPath, let edge, let behavior):
                surface.present(content1, asPopoverRelativeTo: rect, of: surface[keyPath: viewPath] as! NSView, preferredEdge: edge, behavior: behavior)
            case .custom(let animator): surface.present(content1, animator: animator)
            }
            CATransaction.commit()
            return (nextState, (content0, content0))
        }

        public func hierarchyTest(from fromContent: From.Content, to toContent: Too.NestedScreen.Content) -> Bool {
            fromContent === toContent.presentingViewController
        }
        public func updateContent(_ content: Too.NestedScreen.Content, context: Context) {
            to.updateNestedContent(content, with: context)
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
    public func present<From>(style: AppKit.Present<From, Self>.Style = .modal, animated: Bool = true) -> AppKit.Present<From, Self> {
        Presentation.AppKit(self, style: style, animated: animated)
    }
}

extension Router where From.Content: NSTabViewController {
    public subscript<T>(select path: KeyPath<PathFrom, T>) -> StartPath<Tab.AppKitTransition<From, T>> where T: UnwrappedScreen {
        let screen = self[next: path]
        let transition = Tab.AppKitTransition<From, T>(index: index(of: path), path: path, to: screen)
        return StartPath<Tab.AppKitTransition<From, T>>(keyPath: path, transition: transition, context: .strong(()), state: state)
    }
    public func select<T>(_ path: KeyPath<PathFrom, T>) -> StartPath<Tab.AppKitTransition<From, T>> where T: UnwrappedScreen {
        let screen = self[next: path]
        let transition = Tab.AppKitTransition<From, T>(index: index(of: path), path: path, to: screen)
        return StartPath<Tab.AppKitTransition<From, T>>(keyPath: path, transition: transition, context: .strong(()), state: state)
    }
}
extension ScreenPath where To.NestedScreen.Content: NSTabViewController {
    public subscript<T>(select path: KeyPath<PathFrom, T>) -> NextPath<Self, Tab.AppKitTransition<To.NestedScreen, T>> where T: UnwrappedScreen {
        let screen = self[next: path]
        let transition = Tab.AppKitTransition<To.NestedScreen, T>(index: index(of: path), path: path, to: screen)
        return NextPath<Self, Tab.AppKitTransition<To.NestedScreen, T>>(keyPath: path, prev: self, transition: transition, context: .strong(()), state: (self as! ScreenPathPrivate)._state?.next)
    }
    public func select<T>(_ path: KeyPath<PathFrom, T>) -> NextPath<Self, Tab.AppKitTransition<To.NestedScreen, T>> where T: UnwrappedScreen {
        let screen = self[next: path]
        let transition = Tab.AppKitTransition<To.NestedScreen, T>(index: index(of: path), path: path, to: screen)
        return NextPath<Self, Tab.AppKitTransition<To.NestedScreen, T>>(keyPath: path, prev: self, transition: transition, context: .strong(()), state: (self as! ScreenPathPrivate)._state?.next)
    }
}
#endif
