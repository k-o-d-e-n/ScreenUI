//
//  Tab2ViewController.swift
//  ScreenUI_UIKit
//
//  Created by Denis Koryttsev on 03.02.2021.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit

final class Tab2ViewController: UIViewController {
    let state: Screens.Router<Tab2>

    init(state: Screens.Router<Tab2>) {
        self.state = state
        super.init(nibName: nil, bundle: nil)

        let title = state[next: \.title]
        self.title = title
        self.tabBarItem.title = title
        self.navigationItem.title = title
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(openNext))

        let detailLabel = UILabel()
        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        detailLabel.text = "Tab #2"
        view.addSubview(detailLabel)
        NSLayoutConstraint.activate([
            detailLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            detailLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    @objc func openNext() {
        state.move(\.nextScreen, from: self, with: .red, completion: nil)
    }
}
