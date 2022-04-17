//
//  JoinGameView.swift
//  CardBox
//
//  Created by Stuart Long on 30/3/22.
//

import SwiftUI

struct JoinGameView: View {

    @State var gameCode: String = ""
    @ObservedObject private var viewModel = JoinGameViewModel()
    private var playerViewModel = PlayerViewModel()
    @State private var selectedGame: CardBoxGame?

    var body: some View {
        if !viewModel.isJoined {
            Text("Enter Game Code")
            HStack {
                TextField("Game Code", text: $gameCode)
                Button("Submit") {
                    CardBoxMetadataDatabaseManager().getRoomMetadata(
                        gameCode: gameCode,
                        callback: { metadata in
                            switch metadata.type {
                            case .ExplodingKittens:
                                viewModel.loadDatabaseManager(ExplodingKittensDatabaseManager())
                                selectedGame = .ExplodingKittens
                            case .MonopolyDeal:
                                viewModel.loadDatabaseManager(MonopolyDealDatabaseManager())
                                selectedGame = .MonopolyDeal
                            }

                            let gameRoomId = metadata.gameRoomId
                            viewModel.joinRoom(id: gameRoomId, playerViewModel: playerViewModel)
                        })
                }
            }
        } else {
            if let selectedGame = selectedGame {
                JoinGameLobbyView(viewModel: viewModel,
                                  playerViewModel: playerViewModel,
                                  selectedGame: .constant(selectedGame),
                                  gameCode: $gameCode)
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
