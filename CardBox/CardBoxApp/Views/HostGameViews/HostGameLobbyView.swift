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
    @Binding var selectedGame: CardBoxGame
    @Binding var gameCode: String?

    var body: some View {
        if viewModel.gameStarted, let gameRunner = viewModel.gameRunner, let playerIndex = viewModel.playerIndex {
            if selectedGame == .ExplodingKittens, let gameRunner = gameRunner as? ExplodingKittensGameRunner {
                ExplodingKittensOnlineView(gameRunnerViewModel: gameRunner, localPlayerIndex: playerIndex)
            } else if selectedGame == .MonopolyDeal, let gameRunner = gameRunner as? MonopolyDealGameRunner {
                MonopolyDealOnlineView(gameRunnerViewModel: gameRunner, localPlayerIndex: playerIndex)
            } else {
                EmptyView()
            }
        } else {
            VStack(spacing: 10) {
                HStack {
                    Text("Pass this code to your friends to join: ")
                        .font(.system(size: 40))
                    Text(gameCode ?? "Generating...")
                        .font(.system(size: 40))
                        .foregroundColor(.blue)
                }
                ForEach(viewModel.players, id: \.self) { player in
                    Text(player)
                        .font(.system(size: 40))
                }

                Button(action: {
                    // check if game is full first before starting
                    if viewModel.isRoomFull {
                        print("online game started")
                        viewModel.startGame()
//                        appState.page = .onlineGame
                    }
                }) {
                    Text("Start")
                        .font(.system(size: 40))
                }
                .disabled(!viewModel.isRoomFull)
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
        HostGameLobbyView(viewModel: HostGameViewModel(),
                          playerViewModel: PlayerViewModel(),
                          selectedGame: .constant(.ExplodingKittens),
                          gameCode: .constant("ABCD"))
    }
}
