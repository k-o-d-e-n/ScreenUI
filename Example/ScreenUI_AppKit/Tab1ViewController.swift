//
//  Tab1ViewController.swift
//  ScreenUI_AppKit
//
//  Created by Denis Koryttsev on 02.02.2021.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import AppKit

final class Tab1ViewController: NSViewController {
    let state: Screens.Router<Tab1>

    init(state: Screens.Router<Tab1>) {
        self.state = state
        super.init(nibName: nil, bundle: nil)

        self.title = state[next: \.title]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = NSView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let detailLabel = NSTextField()
        detailLabel.isEditable = false
        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        detailLabel.stringValue = "Tab #1"
        view.addSubview(detailLabel)
        NSLayoutConstraint.activate([
            detailLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            detailLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])

        let detailButton = NSButton()
        detailButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(detailButton)
        NSLayoutConstraint.activate([
            detailButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            detailButton.topAnchor.constraint(equalTo: detailLabel.bottomAnchor, constant: 10)
        ])
        detailButton.target = self
        detailButton.action = #selector(openNext)
    }

    @objc func openNext() {
        state.move(\.nextScreen, from: self, with: "Detail text", completion: nil)
    }
}
