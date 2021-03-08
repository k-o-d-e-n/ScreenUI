//
//  PresentedViewController.swift
//  ScreenUI
//
//  Created by Denis Koryttsev on 03.02.2021.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

#if os(macOS)
import AppKit
#else
import UIKit
#endif

final class PresentedViewController: Controller {
    let state: Screens.Router<PresentedScreen>
    let context: Color

    init(state: Screens.Router<PresentedScreen>, context: PresentedScreen.Context) {
        self.state = state
        self.context = context
        super.init(nibName: nil, bundle: nil)

        let title = state[next: \.title]
        self.title = title
        #if !os(macOS)
        self.tabBarItem.title = title
        self.navigationItem.title = title
        #endif
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    #if os(macOS)
    override func loadView() {
        view = NSView(frame: NSScreen.main?.visibleFrame ?? .zero)
    }
    #endif

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = context

        let detailButton = Button(title: "Back", target: self, action: #selector(closeScreen))
        detailButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(detailButton)
        NSLayoutConstraint.activate([
            detailButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            detailButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    @objc func closeScreen() {
        state.back()
    }
}
