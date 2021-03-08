//
//  Tab2View.swift
//  ScreenUI_SwiftUI
//
//  Created by Denis Koryttsev on 03.02.2021.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import SwiftUI

struct Tab2View: View {
    let state: Screens.Router<Tab2>

    var body: some View {
        VStack {
            Text("Tab #2")
            state.move(
                \.nextScreen,
                context: .red,
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

struct Tab2View_Previews: PreviewProvider, Namespace {
    static var previews: some View {
        Tab2View(state: .root(from: Tab2(nextScreen: Screens.AnyTransition(Present(PresentedScreen())))))
    }
}
