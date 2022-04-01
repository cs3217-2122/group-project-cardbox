//
//  MenuButtonsView.swift
//  CardBox
//
//  Created by Stuart Long on 19/3/22.
//

import SwiftUI

struct MenuButtonsView: View {
    @EnvironmentObject private var appState: AppState

    var body: some View {
        Button {
            appState.page = .game
        } label: {
            Text("Play Offline")
                .font(.title)
                .frame(width: 400, height: 100)
                .border(Color.black)
                .foregroundColor(Color.orange)
                .background(Color.blue)
        }
        .accessibilityIdentifier("LaunchOfflineGame")
        Button {
            appState.page = .hostGame
        } label: {
            Text("Host Game")
                .font(.title)
                .frame(width: 400, height: 100)
                .border(Color.black)
                .foregroundColor(Color.orange)
                .background(Color.blue)
        }
        Button {
            appState.page = .joinGame
        } label: {
            Text("Join Game")
                .font(.title)
                .frame(width: 400, height: 100)
                .border(Color.black)
                .foregroundColor(Color.orange)
                .background(Color.blue)
        }
        Spacer()
    }
}

struct MenuButtonsView_Previews: PreviewProvider {
    static var previews: some View {
        MenuButtonsView()
    }
}
