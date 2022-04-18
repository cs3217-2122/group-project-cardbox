//
//  ContentView.swift
//  CardBox
//
//  Created by mactest on 10/03/2022.
//

import SwiftUI

class AppState: ObservableObject {
    @Published var localPlayerIndex = 0
    @Published var page = Page.mainMenu
}

enum Page {
    case mainMenu
    case hostGame
    case joinGame
    case offlineGame
}

struct ContentView: View {
    @StateObject private var appState = AppState()

    var body: some View {
        if appState.page == .mainMenu {
            MainMenuView()
                .environmentObject(appState)
        } else if appState.page == .offlineGame {
            OfflineGameView()
                .environmentObject(appState)
        } else if appState.page == .hostGame {
            HostGameView()
                .environmentObject(appState)
        } else if appState.page == .joinGame {
            JoinGameView()
                .environmentObject(appState)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
