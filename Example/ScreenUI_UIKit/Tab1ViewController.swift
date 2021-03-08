//
//  ViewController.swift
//  ScreenUI
//
//  Created by k-o-d-e-n on 02/02/2021.
//  Copyright (c) 2021 k-o-d-e-n. All rights reserved.
//

import UIKit

final class Tab1ViewController: UIViewController {
    let state: Screens.Router<Tab1>

    init(state: Screens.Router<Tab1>) {
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

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Detail", style: .done, target: self, action: #selector(openDetail))

        let detailLabel = UILabel()
        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        detailLabel.text = "Tab #1"
        view.addSubview(detailLabel)
        NSLayoutConstraint.activate([
            detailLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            detailLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    @objc func openDetail() {
        state.move(\.nextScreen, from: self, with: "Detail text", completion: nil)
    }
}

