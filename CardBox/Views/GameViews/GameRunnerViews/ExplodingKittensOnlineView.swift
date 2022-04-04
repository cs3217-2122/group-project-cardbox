//
//  ExplodingKittensOnlineView.swift
//  CardBox
//
//  Created by Bernard Wan on 1/4/22.
//

import SwiftUI

struct ExplodingKittensOnlineView: View {
    @StateObject var gameRunnerViewModel: ExplodingKittensGameRunner
    @State var error = true
    @State var selectedPlayerViewModel: PlayerViewModel?
    @State var cardPreview: Card?
    var localPlayerIndex: Int

    var body: some View {
        ZStack {
            Color.green
                .ignoresSafeArea()
            VStack {
                if let localPlayer = gameRunnerViewModel.players.getPlayerByIndex(localPlayerIndex) {
                    let bottomPlayerViewModel = PlayerViewModel(
                        player: localPlayer,
                        hand: gameRunnerViewModel.getHandByPlayer(localPlayer) ?? CardCollection()
                    )
                    NonPlayerView(
                        error: $error, localPlayerIndex: localPlayerIndex,
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
            WinMessageView()
        }
        .sheet(isPresented: $gameRunnerViewModel.isShowingPeek, onDismiss: dismissPeek) {
            PeekCardsView(cards: gameRunnerViewModel.cardsPeeking)
        }
        .environmentObject(GameRunnerDelegate(runner: gameRunnerViewModel))
//        .onAppear(perform: setup)
    }

    private func setup() {
//        gameRunnerViewModel.initialiseFrom(explodingKittensGameRunnerInitialiser)
    }

    func dismissPeek() {
        gameRunnerViewModel.isShowingPeek = false
    }
}
