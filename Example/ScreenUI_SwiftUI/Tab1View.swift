//
//  ContentView.swift
//  ScreenUI-SwiftUI
//
//  Created by Denis Koryttsev on 02.02.2021.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import SwiftUI

struct Tab1View: View {
    let state: Screens.Router<Tab1>

    var body: some View {
        VStack {
            Text("Tab #1")
            state.move(
                \.nextScreen,
                context: "Detail text",
                action: Text("Next"),
                completion: nil
            )
        }
        .navigationTitle(state[next: \.title])
    }
}

struct Tab1View_Previews: PreviewProvider, Namespace {
    static var previews: some View {
        Tab1View(state: .root(from: Tab1(nextScreen: Screens.AnyTransition(Push(DetailScreen(nextScreen: nil))))))
    }
}
