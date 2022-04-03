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
    var playerViewModel: PlayerViewModel
    @EnvironmentObject private var appState: AppState

    var body: some View {
        if viewModel.gameStarted, let gameRunner = viewModel.gameRunner {
            ExplodingKittensOnlineView(gameRunnerViewModel: gameRunner, localPlayerIndex: 1)
        } else {
            VStack {
                HStack {
                    Text("Pass this code to your friends to join: ")
                    Text(viewModel.gameRoomID).foregroundColor(.blue)
                }
                ForEach(viewModel.players, id: \.self) { player in
                    Text(player)
                }

                Button("Start") {
                    // check if game is full first before starting
                    if viewModel.isRoomFull {
                        print("online game started")
                        viewModel.startGame()
//                        appState.page = .onlineGame
                    }
                }.foregroundColor(.red)
            }
            .onChange(of: scenePhase) { newPhase in
                if newPhase == .background {
                    viewModel.removeFromRoom(playerViewModel: playerViewModel)
                }
            }
        }
    }
}

struct HostGameLobbyView_Previews: PreviewProvider {
    static var previews: some View {
        HostGameLobbyView(viewModel: HostGameViewModel(), playerViewModel: PlayerViewModel())
    }
}
