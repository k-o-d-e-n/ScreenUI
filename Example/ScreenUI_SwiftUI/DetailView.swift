//
//  DetailView.swift
//  ScreenUI_SwiftUI
//
//  Created by Denis Koryttsev on 03.02.2021.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import SwiftUI

struct DetailView: View {
    let state: Screens.Router<DetailScreen>
    let context: String

    var body: some View {
        VStack {
            Text(context)
                .navigationBarTitle(state[next: \.title])
            if let view = state.move(
                \.nextScreen,
                context: "Subdetail text!!1",
                action: { bool in
                    Button(
                        action: {
                            bool.wrappedValue = true
                        },
                        label: { Text("Next") }
                    )
                },
                completion: nil
            ) {
                view
            } else {
                Button(
                    action: { state.back() },
                    label: { Text("Back") }
                )
            }
        }
    }
}

struct DetailView_Preview: PreviewProvider {
    static var previews: some View {
        DetailView(state: .root(from: DetailScreen(nextScreen: nil)), context: "Detail text")
    }
}
