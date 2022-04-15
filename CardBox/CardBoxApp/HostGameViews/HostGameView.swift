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

    var body: some View {
        VStack {
            if viewModel.gameRoomID.isEmpty {
                Button("Exploding Kittens") {
                    selectedGame = .ExplodingKittens
                    viewModel.loadDatabaseManager(ExplodingKittensDatabaseManager())
                }.foregroundColor(selectedGame == .ExplodingKittens ? .red : .blue)
                Button("Monopoly Deal") {
                    selectedGame = .MonopolyDeal
                    viewModel.loadDatabaseManager(MonopolyDealDatabaseManager())
                }.foregroundColor(selectedGame == .MonopolyDeal ? .red : .blue)

                Button("Host Game") {
                    if let selectedGame = selectedGame {
                        print("host game button pressed")
                        viewModel.createRoom(playerViewModel: playerViewModel)
                        print(viewModel.gameRoomID)
                    }
                }
            } else {
                if let selectedGame = selectedGame {
                    HostGameLobbyView(viewModel: viewModel,
                                      playerViewModel: playerViewModel,
                                      selectedGame: .constant(selectedGame))
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
