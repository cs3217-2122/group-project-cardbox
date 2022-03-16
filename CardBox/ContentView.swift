//
//  ContentView.swift
//  CardBox
//
//  Created by mactest on 10/03/2022.
//

import SwiftUI

class AppState: ObservableObject {

    @Published var page = Page.mainMenu
}

enum Page {
    case game
    case mainMenu
}


struct ContentView: View {
    @StateObject private var appState = AppState()
    
    var body: some View {
        if appState.page == .mainMenu {
            MainMenuView()
                .environmentObject(appState)
        } else if appState.page == .game {
            GameRunnerView()
                .environmentObject(appState)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
