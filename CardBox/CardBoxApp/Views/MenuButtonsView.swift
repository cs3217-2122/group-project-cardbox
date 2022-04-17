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
                .foregroundColor(Color(red: 0.851, green: 0.310, blue: 0.015_7))
                .background(Color(red: 0.655, green: 0.243, blue: 0.361))
        }
        .accessibilityIdentifier("LaunchOfflineGame")
        Button {
            appState.page = .monopolyDeal
        } label: {
            Text("Play Monopoly Deal")
                .font(.title)
                .frame(width: 400, height: 100)
                .border(Color.black)
                .foregroundColor(Color(red: 0.851, green: 0.310, blue: 0.015_7))
                .background(Color(red: 0.655, green: 0.243, blue: 0.361))
        }
        Button {
            appState.page = .hostGame
        } label: {
            Text("Host Game")
                .font(.title)
                .frame(width: 400, height: 100)
                .border(Color.black)
                .foregroundColor(Color(red: 0.851, green: 0.310, blue: 0.015_7))
                .background(Color(red: 0.655, green: 0.243, blue: 0.361))
        }
        Button {
            appState.page = .joinGame
        } label: {
            Text("Join Game")
                .font(.title)
                .frame(width: 400, height: 100)
                .border(Color.black)
                .foregroundColor(Color(red: 0.851, green: 0.310, blue: 0.015_7))
                .background(Color(red: 0.655, green: 0.243, blue: 0.361))
        }
        Spacer()
    }
}

struct MenuButtonsView_Previews: PreviewProvider {
    static var previews: some View {
        MenuButtonsView()
    }
}
