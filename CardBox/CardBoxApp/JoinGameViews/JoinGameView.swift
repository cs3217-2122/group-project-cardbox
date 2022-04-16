//
//  JoinGameView.swift
//  CardBox
//
//  Created by Stuart Long on 30/3/22.
//

import SwiftUI

struct JoinGameView: View {

    @State var gameRoomID: String = ""
    @ObservedObject private var viewModel = JoinGameViewModel()
    private var playerViewModel = PlayerViewModel()
    @State private var selectedGame: CardBoxGame?

    var body: some View {
        if !viewModel.isJoined {
            Button("Exploding Kittens") {
                selectedGame = .ExplodingKittens
                viewModel.loadDatabaseManager(ExplodingKittensDatabaseManager())
            }.foregroundColor(selectedGame == .ExplodingKittens ? .red : .blue)
            Button("Monopoly Deal") {
                selectedGame = .MonopolyDeal
                viewModel.loadDatabaseManager(MonopolyDealDatabaseManager())
            }.foregroundColor(selectedGame == .MonopolyDeal ? .red : .blue)

            Text("Enter Game Room ID")
            HStack {
                TextField("Game Room ID", text: $gameRoomID)
                Button("Submit") {
                    print("submit button pressed")
                    if let selectedGame = selectedGame, gameRoomID.isEmpty {
                        // TODO: Change to popup or alert or something
                        print("game room id cannot be empty or no game selected")
                    } else {
                        viewModel.joinRoom(id: gameRoomID, playerViewModel: playerViewModel)
                    }
                }
            }
        } else {
            if let selectedGame = selectedGame {
                JoinGameLobbyView(viewModel: viewModel,
                                  playerViewModel: playerViewModel,
                                  selectedGame: .constant(selectedGame))
            } else {
                EmptyView()
            }
        }
    }
}

struct JoinGameView_Previews: PreviewProvider {
    static var previews: some View {
        JoinGameView()
    }
}
