//
//  Misc.swift
//  ScreenUI
//
//  Created by Denis Koryttsev on 03.02.2021.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

#if SWIFTUI
import SwiftUI

typealias Image = SwiftUI.Image
typealias Color = SwiftUI.Color
typealias RoutingSurface = View

#elseif APPKIT
import AppKit

typealias RoutingSurface = NSViewController
typealias TabsController = NSTabViewController
typealias Color = NSColor
typealias Image = NSImage
typealias Button = NSButton

extension NSImage {
    convenience init?(systemName: String) {
        self.init(systemSymbolName: systemName, accessibilityDescription: nil)
    }
}
extension NSView {
    var backgroundColor: NSColor? {
        set { layer?.backgroundColor = newValue?.cgColor }
        get { layer?.backgroundColor.flatMap(NSColor.init(cgColor:)) }
    }
}
extension NSViewController {
    func dismiss() {
        dismiss(self)
    }
}

#elseif UIKIT
import UIKit

typealias TabsController = UITabBarController
typealias RoutingSurface = UIViewController
typealias Color = UIColor
typealias Image = UIImage
typealias Button = UIButton
extension UIButton {
    convenience init(title: String, target: Any?, action: Selector?) {
        self.init()
        setTitle(title, for: .normal)
        if let target = target, let action = action {
            addTarget(target, action: action, for: .touchUpInside)
        }
    }
}
extension UIViewController {
    func dismiss() {
        dismiss(animated: true)
    }
}

#endif
