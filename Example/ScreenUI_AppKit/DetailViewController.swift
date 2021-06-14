//
//  DetailViewController.swift
//  ScreenUI_AppKit
//
//  Created by Denis Koryttsev on 03.02.2021.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import AppKit

final class DetailViewController: NSViewController {
    let state: Screens.Router<DetailScreen>
    let text: String

    init(state: Screens.Router<DetailScreen>, context: String) {
        self.state = state
        self.text = context
        super.init(nibName: nil, bundle: nil)

        self.title = state[next: \.title]
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = NSView(frame: NSRect(x: 0, y: 0, width: 500, height: 500))
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let detailLabel = NSTextField()
        detailLabel.isEditable = false
        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        detailLabel.stringValue = text
        view.addSubview(detailLabel)
        NSLayoutConstraint.activate([
            detailLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            detailLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
}
