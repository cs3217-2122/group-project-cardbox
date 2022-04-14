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

    @ViewBuilder
    var centerArea: some View {
        HStack {
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
    }

    func getNonPlayer(bottomPlayerViewModel: PlayerViewModel) -> some View {
        NonPlayerView(
            error: $error,
            localPlayerIndex: localPlayerIndex,
            bottomPlayerViewModel: bottomPlayerViewModel,
            selectedPlayerViewModel: $selectedPlayerViewModel,
            selectedCardSetViewModel: .constant(nil),
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
                centerArea
            }
        )
    }

    func getCurrentPlayer(bottomPlayerViewModel: PlayerViewModel) -> some View {
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

    var body: some View {
        ZStack {
            Color.green
                .ignoresSafeArea()
            if let localPlayer = gameRunnerViewModel.gameState.players.getPlayerByIndex(localPlayerIndex) {
                let bottomPlayerViewModel = PlayerViewModel(
                    player: localPlayer,
                    hand: gameRunnerViewModel.getHandByPlayer(localPlayer) ?? CardCollection()
                )
                VStack {
                    getNonPlayer(bottomPlayerViewModel: bottomPlayerViewModel)
                    Spacer()
                    getCurrentPlayer(bottomPlayerViewModel: bottomPlayerViewModel)
                }
            }
            CardPreviewView()
            CardTypeRequestView(cardTypeRequest: $gameRunnerViewModel.cardTypeRequest)
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
