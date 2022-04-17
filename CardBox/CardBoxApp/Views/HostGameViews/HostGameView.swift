//
//  HostGameView.swift
//  CardBox
//
//  Created by Stuart Long on 30/3/22.
//

import SwiftUI

struct HostGameView: View {

    @ObservedObject private var viewModel = HostGameViewModel()
    private var playerViewModel = PlayerViewModel()
    @State private var selectedGame: CardBoxGame?
    @State private var gameCode: String?

    var ekButton: some View {
        Button("Exploding Kittens") {
            selectedGame = .ExplodingKittens
            viewModel.loadDatabaseManager(ExplodingKittensDatabaseManager())
        }.foregroundColor(selectedGame == .ExplodingKittens ? .red : .blue)
    }

    var mdButton: some View {
        Button("Monopoly Deal") {
            selectedGame = .MonopolyDeal
            viewModel.loadDatabaseManager(MonopolyDealDatabaseManager())
        }.foregroundColor(selectedGame == .MonopolyDeal ? .red : .blue)
    }

    var hostButton: some View {
        Button("Host Game") {
            if let selectedGame = selectedGame {
                viewModel.createRoom(playerViewModel: playerViewModel)
                gameCode = CardBoxMetadataDatabaseManager().createRoomMetadata(
                    gameRoomId: viewModel.gameRoomID,
                    gameType: selectedGame
                )
                print(viewModel.gameRoomID)
            }
        }
    }

    var body: some View {
        VStack {
            if viewModel.gameRoomID.isEmpty {
                ekButton
                mdButton
                hostButton
            } else {
                if let selectedGame = selectedGame {
                    HostGameLobbyView(viewModel: viewModel,
                                      playerViewModel: playerViewModel,
                                      selectedGame: .constant(selectedGame),
                                      gameCode: $gameCode)
                } else {
                    EmptyView()
                }
            }
        }
    }
}

struct HostGameView_Previews: PreviewProvider {
    static var previews: some View {
        HostGameView()
    }
}
