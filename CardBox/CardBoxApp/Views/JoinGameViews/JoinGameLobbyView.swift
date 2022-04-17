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
    @Binding var gameCode: String

    var gameNameText: String {
        switch selectedGame {
        case .ExplodingKittens:
            return "Exploding Kittens"
        case .MonopolyDeal:
            return "Monopoly Deal"
        }
    }

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
                Text("You are now playing: " + gameNameText)
                    .font(.system(size: 40))
                HStack {
                    Text("Game Code: ")
                        .font(.system(size: 30))
                    Text(gameCode)
                        .font(.system(size: 30))
                        .foregroundColor(.blue)

                }
                VStack {
                    Text("Players in Lobby:")
                        .font(.system(size: 30))
                    ForEach(viewModel.players, id: \.self) { player in
                        Text(player)
                            .font(.system(size: 30))
                    }
                }
                .padding()
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
        JoinGameLobbyView(viewModel: JoinGameViewModel(),
                          playerViewModel: PlayerViewModel(),
                          selectedGame: .constant(.ExplodingKittens),
                          gameCode: .constant("ABCD"))
    }
}
