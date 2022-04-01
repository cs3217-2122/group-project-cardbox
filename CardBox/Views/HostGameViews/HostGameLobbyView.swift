//
//  HostGameLobbyView.swift
//  CardBox
//
//  Created by Stuart Long on 1/4/22.
//

import SwiftUI

struct HostGameLobbyView: View {

    @Environment(\.scenePhase) private var scenePhase
    @ObservedObject var viewModel: HostGameViewModel
    @EnvironmentObject private var appState: AppState

    var body: some View {
        VStack {
            HStack {
                Text("Pass this code to your friends to join: ")
                Text(viewModel.gameRoomID).foregroundColor(.blue)
            }
            ForEach(viewModel.players, id: \.self) { player in
                Text(player)
            }

            Button("Start") {
                print("online game started")
                appState.page = .onlineGame
            }.foregroundColor(.red)
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .background {
                viewModel.removeFromRoom()
            }
        }
    }
}

struct HostGameLobbyView_Previews: PreviewProvider {
    static var previews: some View {
        HostGameLobbyView(viewModel: HostGameViewModel())
    }
}
