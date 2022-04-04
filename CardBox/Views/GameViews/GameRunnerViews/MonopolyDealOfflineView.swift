//
//  MonopolyDealOfflineView.swift
//  CardBox
//
//  Created by Bernard Wan on 2/4/22.
//

import SwiftUI

struct MonopolyDealOfflineView: View {
    @StateObject var gameRunnerViewModel = MonopolyDealGameRunner()
    @State var error = true
    @State var selectedPlayerViewModel: PlayerViewModel?
    @State var cardPreview: Card?

    var body: some View {
        ZStack {
            Color.green
                .ignoresSafeArea()
            VStack {
                if let currentPlayer = gameRunnerViewModel.players.currentPlayer {
                    let bottomPlayerViewModel = PlayerViewModel(
                        player: currentPlayer,
                        hand: gameRunnerViewModel.getHandByPlayer(currentPlayer)
                    )
                    NonBottomPlayerView(
                        error: $error,
                        bottomPlayerViewModel: bottomPlayerViewModel,
                        selectedPlayerViewModel: $selectedPlayerViewModel,
                        playerArea: { player in
                            MDPlayerView(
                                playerViewModel: PlayerViewModel(
                                    player: player,
                                    hand: gameRunnerViewModel.getHandByPlayer(player)
                                ),
                                currentPlayerViewModel: bottomPlayerViewModel,
                                playerPlayAreaViewModel: PlayerPlayAreaViewModel(sets: []),
                                error: $error
                            )
                        },
                        center: {
                            DeckView(
                                deckViewModel: DeckViewModel(
                                    deck: gameRunnerViewModel.deck,
                                    isPlayDeck: false,
                                    gameRunner: gameRunnerViewModel
                                ),
                                isFaceUp: false
                            )
                            DeckView(
                                deckViewModel: DeckViewModel(
                                    deck: gameRunnerViewModel.gameplayArea,
                                    isPlayDeck: true,
                                    gameRunner: gameRunnerViewModel
                                ),
                                isFaceUp: true
                            )
                        }
                    )

                    Spacer()

                    BottomPlayerView(
                        playerArea: {
                            MDPlayerView(
                                playerViewModel: bottomPlayerViewModel,
                                currentPlayerViewModel: bottomPlayerViewModel,
                                playerPlayAreaViewModel: PlayerPlayAreaViewModel(sets: []),
                                error: $error
                            )
                        }
                    )
                }
            }
            CardPreviewView()
            WinMessageView()
        }
        .environmentObject(GameRunnerDelegate(runner: gameRunnerViewModel))
        .onAppear(perform: setup)
    }

    private func setup() {
        gameRunnerViewModel.setup()
    }

}
