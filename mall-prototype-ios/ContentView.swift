//
//  ContentView.swift
//  mall-prototype-ios
//
//  Created by besim@shortcut on 21.5.25.
//

import SwiftUI

struct ContentView: View {
    @State private var showMainView = false

    var body: some View {
        Group {
            if showMainView {
                MainView()
            } else {
                IntroPage(onFinish: {
                    withAnimation {
                        showMainView = true
                    }
                })
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
