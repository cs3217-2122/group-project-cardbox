//
//  JoinGameLobbyView.swift
//  CardBox
//
//  Created by Stuart Long on 1/4/22.
//

import SwiftUI

struct JoinGameLobbyView: View {

    @Environment(\.scenePhase) private var scenePhase
    @ObservedObject var viewModel: JoinGameViewModel
    var playerViewModel: PlayerViewModel
    @Binding var selectedGame: CardBoxGame

    var body: some View {
        if viewModel.gameStarted, let gameRunner = viewModel.gameRunner, let playerIndex = viewModel.playerIndex {
            if selectedGame == .ExplodingKittens, let gameRunner = gameRunner as? ExplodingKittensGameRunner {
                ExplodingKittensOnlineView(gameRunnerViewModel: gameRunner, localPlayerIndex: playerIndex)
            } else if selectedGame == .MonopolyDeal, let gameRunner = gameRunner as? MonopolyDealGameRunner {
                // TODO: Replace with MonopolyDealOnlineView
                EmptyView()
            } else {
                EmptyView()
            }
        } else {
            VStack {
                Text("Game Room ID: \(viewModel.gameRoomID)")
                Text("Players in Lobby")
                ForEach(viewModel.players, id: \.self) { player in
                    Text(player)
                }
            }
            .onChange(of: scenePhase) { newPhase in
                if newPhase == .background {
                    viewModel.removeFromRoom(playerViewModel: playerViewModel)
                }
            }
        }
    }
}

struct JoinGameLobbyView_Previews: PreviewProvider {
    static var previews: some View {
        JoinGameLobbyView(viewModel: JoinGameViewModel(), playerViewModel: PlayerViewModel())
    }
}
