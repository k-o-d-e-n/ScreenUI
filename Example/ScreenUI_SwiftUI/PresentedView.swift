//
//  PresentedView.swift
//  ScreenUI_SwiftUI
//
//  Created by Denis Koryttsev on 03.02.2021.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import SwiftUI

struct PresentedView: View {
    let state: Screens.Router<PresentedScreen>
    let context: Color

    var body: some View {
        VStack {
            Button(
                action: { state.back(completion: nil) },
                label: { Text("Back").foregroundColor(.white) }
            )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(context)
        .navigationTitle(state[next: \.title])
    }
}

struct PresentedView_Previews: PreviewProvider {
    static var previews: some View {
        PresentedView(state: .root(from: PresentedScreen()), context: .white)
    }
}
