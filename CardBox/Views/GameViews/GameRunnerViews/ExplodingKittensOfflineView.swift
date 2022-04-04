//
//  GameRunnerView.swift
//  CardBox
//
//  Created by mactest on 12/03/2022.
//

import SwiftUI

struct ExplodingKittensOfflineView: View {
    @StateObject var gameRunnerViewModel = ExplodingKittensGameRunner()
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
                        hand: gameRunnerViewModel.getHandByPlayer(currentPlayer) ?? CardCollection()
                    )
                    NonBottomPlayerView(
                        error: $error,
                        bottomPlayerViewModel: bottomPlayerViewModel,
                        selectedPlayerViewModel: $selectedPlayerViewModel,
                        playerArea: { player in
                            EKPlayerView(
                                playerViewModel: PlayerViewModel(
                                    player: player,
                                    hand: gameRunnerViewModel.getHandByPlayer(player) ?? CardCollection()
                                ),
                                currentPlayerViewModel: bottomPlayerViewModel,
                                error: $error,
                                selectedPlayerViewModel: $selectedPlayerViewModel
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
                            EKPlayerView(
                                playerViewModel: bottomPlayerViewModel,
                                currentPlayerViewModel: bottomPlayerViewModel,
                                error: $error,
                                selectedPlayerViewModel: $selectedPlayerViewModel
                            )
                        }
                    )
                }
            }
            CardPreviewView()
            PositionRequestView(cardPositionRequest: $gameRunnerViewModel.deckPositionRequest)
            CardTypeRequestView(cardTypeRequest: $gameRunnerViewModel.cardTypeRequest)
            WinMessageView()
        }
        .sheet(isPresented: $gameRunnerViewModel.isShowingPeek, onDismiss: dismissPeek) {
            PeekCardsView(cards: gameRunnerViewModel.cardsPeeking)
        }
        .environmentObject(GameRunnerDelegate(runner: gameRunnerViewModel))
        .onAppear(perform: setup)
    }

    private func setup() {
        gameRunnerViewModel.setup()
    }

    func dismissPeek() {
        gameRunnerViewModel.isShowingPeek = false
    }
}
