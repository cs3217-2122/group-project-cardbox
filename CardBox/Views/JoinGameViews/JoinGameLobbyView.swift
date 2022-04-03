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

    var body: some View {
        if viewModel.gameStarted, let gameRunner = viewModel.gameRunner {
            ExplodingKittensOnlineView(gameRunnerViewModel: gameRunner, localPlayerIndex: 1)
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
