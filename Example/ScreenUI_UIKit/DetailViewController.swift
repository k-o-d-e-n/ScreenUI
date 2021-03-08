//
//  DetailViewController.swift
//  ScreenUI_UIKit
//
//  Created by Denis Koryttsev on 03.02.2021.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit

final class DetailViewController: UIViewController {
    let state: Screens.Router<DetailScreen>
    let text: String

    init(state: Screens.Router<DetailScreen>, context: DetailScreen.Context) {
        self.state = state
        self.text = context
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

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(openSubdetail))

        let detailLabel = UILabel()
        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        detailLabel.text = text
        view.addSubview(detailLabel)
        NSLayoutConstraint.activate([
            detailLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            detailLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        let backButton = Button(title: "Back", target: self, action: #selector(closeScreen))
        backButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backButton)
        NSLayoutConstraint.activate([
            backButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backButton.topAnchor.constraint(equalTo: detailLabel.bottomAnchor, constant: 10)
        ])

        let tab2Button = Button(title: "Tab2", target: self, action: #selector(showTab2))
        tab2Button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tab2Button)
        NSLayoutConstraint.activate([
            tab2Button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tab2Button.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 10)
        ])
    }

    @objc func closeScreen() {
        state.back()
    }
    @objc func showTab2() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.screens.router[root: .init(root: (tab1: .init(), tab2: .init()))][select: \.1][move: \.nextScreen, .blue].move(from: (), completion: nil)
    }
    @objc func openSubdetail() {
        state.move(\.nextScreen, from: self, with: "SUB DETAIL!11")
    }
}
