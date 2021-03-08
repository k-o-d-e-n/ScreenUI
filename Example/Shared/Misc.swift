//
//  Misc.swift
//  ScreenUI
//
//  Created by Denis Koryttsev on 03.02.2021.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

#if SWIFTUI
import SwiftUI

typealias Color = SwiftUI.Color

#elseif APPKIT
import AppKit

typealias Controller = NSViewController
typealias TabsController = NSTabViewController
typealias Color = NSColor
typealias Button = NSButton

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
typealias Controller = UIViewController
typealias Color = UIColor
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
