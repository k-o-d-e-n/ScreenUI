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

    @Environment(\.appRouter) var appRouter: AppRouter

    var body: some View {
        VStack {
            Text(context).fontWeight(.heavy).font(.title)
            Divider().padding()
            if let view = state.move(
                \.nextScreen,
                context: "Subdetail text!!1",
                action: { state in
                    Text("Optional transition").bold()
                    Button("Open sub-detail") { state.wrappedValue = true }
                    Text("Open the same screen with other context")
                        .italic()
                        .font(.caption)
                },
                completion: nil
            ) {
                view
                Divider().padding()
                Text("Open tab2 screen through global router").bold()
                Button("Tab2") {
                    appRouter
                        .select(\.1)
                        .move(\.nextScreen)
                        .move(from: (), completion: nil)
                }
                Text("Simultaneously opens next screen")
                    .italic()
                    .font(.caption)
            } else {
                Button("Back") { state.back() }
            }
        }
        .navigationTitle(state[next: \.title])
    }
}

struct DetailView_Preview: PreviewProvider {
    static var previews: some View {
        DetailView(state: .root(from: DetailScreen(nextScreen: nil)), context: "Detail text example")
    }
}
