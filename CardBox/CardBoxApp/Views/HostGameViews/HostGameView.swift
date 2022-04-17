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
        Button(action: {
            selectedGame = .ExplodingKittens
            viewModel.loadDatabaseManager(ExplodingKittensDatabaseManager())
        }) {
            Text("Exploding Kittens")
                .font(.system(size: 30))
                .frame(width: 200, height: 200)
                .padding()
                .overlay {
                    if selectedGame == .ExplodingKittens {
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.red, lineWidth: 10)
                    } else {
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.black, lineWidth: 4)
                    }
                }
        }
    }

    var mdButton: some View {
        Button(action: {
            selectedGame = .MonopolyDeal
            viewModel.loadDatabaseManager(MonopolyDealDatabaseManager())
        }) {
            Text("Monopoly Deal")
                .font(.system(size: 30))
                .frame(width: 200, height: 200)
                .padding()
                .overlay {
                    if selectedGame == .MonopolyDeal {
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.red, lineWidth: 10)
                    } else {
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.black, lineWidth: 4)
                    }
                }
        }
    }

    var hostButton: some View {
        Button(action: {
            if let selectedGame = selectedGame {
                viewModel.createRoom(playerViewModel: playerViewModel)
                Task {
                    print("updated game code")
                    gameCode = await CardBoxMetadataDatabaseManager().createRoomMetadata(
                        gameRoomId: viewModel.gameRoomID,
                        gameType: selectedGame
                    )
                }
            }
            print(viewModel.gameRoomID)
        }) {
            Text("Create Room")
                .font(.system(size: 30))
        }
    }

    var body: some View {
        VStack(spacing: 20) {
            if viewModel.gameRoomID.isEmpty {
                Text("Select a Game")
                    .font(.system(size: 50))
                HStack(spacing: 20) {
                    ekButton
                    mdButton
                }
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
