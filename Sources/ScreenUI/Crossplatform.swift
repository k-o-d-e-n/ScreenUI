//
//  Crossplatform.swift
//  Pods
//
//  Created by Denis Koryttsev on 02.03.2021.
//

import Foundation

public enum Win {}
public enum Nav {}
public enum Tab {}

extension Nav {
    public enum Push {
        public enum Pop {}
    }
}
public enum Presentation {
    public enum Dismiss {}
}

#if !os(macOS) && !os(watchOS)
public typealias Controller = UIViewController
#elseif os(macOS)
public typealias Controller = NSViewController
#endif

/// - Namespaces

#if !os(macOS) && !os(watchOS)
public enum UIKit {
    public typealias Window<Root> = Win.UIKit<Root> where Root: Screen, Root.Content: UIViewController
    public typealias Navigation<Root> = Nav.UIKit<Root> where Root: Screen, Root.Content: UIViewController
    public typealias Tabs<Root> = Tab.UIKit<Root> where Root: ScreenBuilder, Root.Content == [UIViewController]

    public typealias Push<From, To> = Nav.Push.UIKit<From, To> where From: ContentScreen, To: Screen, From.Content: UIViewController, To.Content: UIViewController, To.NestedScreen.Content: UIViewController
    public typealias Present<From, To> = Presentation.UIKit<From, To> where From: ContentScreen, To: Screen, From.Content: UIViewController, To.Content: UIViewController, To.NestedScreen.Content: UIViewController
    public typealias Pop<From> = Nav.Push.Pop.UIKit<From> where From: ContentScreen, From.Content: UIViewController
    public typealias Dismiss<From> = Presentation.Dismiss.UIKit<From> where From: ContentScreen, From.Content: UIViewController
}

public protocol UIKitNamespace {
    typealias Window<Root> = Win.UIKit<Root> where Root: Screen, Root.Content: UIViewController
    typealias Navigation<Root> = Nav.UIKit<Root> where Root: Screen, Root.Content: UIViewController
    typealias Tabs<Root> = Tab.UIKit<Root> where Root: ScreenBuilder, Root.Content == [UIViewController]

    typealias Push<From, To> = Nav.Push.UIKit<From, To> where From: ContentScreen, To: Screen, From.Content: UIViewController, To.Content: UIViewController, To.NestedScreen.Content: UIViewController
    typealias Present<From, To> = Presentation.UIKit<From, To> where From: ContentScreen, To: Screen, From.Content: UIViewController, To.Content: UIViewController, To.NestedScreen.Content: UIViewController
    typealias Pop<From> = Nav.Push.Pop.UIKit<From> where From: ContentScreen, From.Content: UIViewController
    typealias Dismiss<From> = Presentation.Dismiss.UIKit<From> where From: ContentScreen, From.Content: UIViewController
}
#elseif os(macOS)
public enum AppKit {
    public typealias Window<Root> = Win.AppKit<Root> where Root: Screen, Root.Content: NSViewController
    public typealias Tabs<Root> = Tab.AppKit<Root> where Root: ScreenBuilder, Root.Content == [NSViewController]

    public typealias Present<From, To> = Presentation.AppKit<From, To> where From: ContentScreen, To: Screen, From.Content: NSViewController, To.Content: NSViewController, To.NestedScreen.Content: NSViewController
    public typealias Dismiss<From> = Presentation.Dismiss.AppKit<From> where From: ContentScreen, From.Content: NSViewController
}

public protocol AppKitNamespace {
    typealias Window<Root> = Win.AppKit<Root> where Root: Screen, Root.Content: NSViewController
    typealias Tabs<Root> = Tab.AppKit<Root> where Root: ScreenBuilder, Root.Content == [NSViewController]

    typealias Present<From, To> = Presentation.AppKit<From, To> where From: ContentScreen, To: Screen, From.Content: NSViewController, To.Content: NSViewController, To.NestedScreen.Content: NSViewController
    typealias Dismiss<From> = Presentation.Dismiss.AppKit<From> where From: ContentScreen, From.Content: NSViewController
}
#endif

#if canImport(SwiftUI) && canImport(Combine)
import SwiftUI

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 7.0, *)
public enum SwiftUI {
    @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
    public typealias Window<Root> = Win.SwiftUI<Root> where Root: Screen, Root.Content: View
    public typealias Navigation<Root> = Nav.SwiftUI<Root> where Root: Screen, Root.Content: View
    public typealias Tabs<Root> = Tab.SwiftUI<Root> where Root: ScreenBuilder

    public typealias Push<From, To> = Nav.Push.SwiftUI<From, To> where From: ContentScreen, To: Screen, To.Content: View
    public typealias Present<From, To> = Presentation.SwiftUI<From, To> where From: ContentScreen, To: Screen, To.Content: View
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 7.0, *)
public protocol SwiftUINamespace {
    @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
    typealias Window<Root> = Win.SwiftUI<Root> where Root: Screen, Root.Content: View
    typealias Navigation<Root> = Nav.SwiftUI<Root> where Root: Screen, Root.Content: View
    typealias Tabs<Root> = Tab.SwiftUI<Root> where Root: ScreenBuilder

    typealias Push<From, To> = Nav.Push.SwiftUI<From, To> where From: ContentScreen, To: Screen, To.Content: View
    typealias Present<From, To> = Presentation.SwiftUI<From, To> where From: ContentScreen, To: Screen, To.Content: View
}
#endif
