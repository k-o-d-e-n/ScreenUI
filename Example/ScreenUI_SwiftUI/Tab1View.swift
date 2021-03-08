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
                action: { (state) in
                    Button(
                        action: { state.wrappedValue = true },
                        label: { Text("Next") }
                    )
                },
                completion: nil
            )
        }
        .tabItem { Text(state[next: \.title]) }
        .navigationBarTitle(state[next: \.title])
    }
}

struct Tab1View_Previews: PreviewProvider, Namespace {
    static var previews: some View {
        Tab1View(state: .root(from: Tab1(nextScreen: Screens.AnyTransition(Push(DetailScreen(nextScreen: nil))))))
    }
}
