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
                    deck: gameRunnerViewModel.deck
            )
            DeckView(
                    deck: gameRunnerViewModel.gameplayArea
            )
        }
    }

    @ViewBuilder
    func playerArea(player: Player) -> some View {
        if let bottomPlayer = gameRunnerViewModel.players.currentPlayer {
            EKPlayerView(
                player: player,
                hand: gameRunnerViewModel.getHandByPlayer(player)
                ?? CardCollection(),
                bottomPlayer: bottomPlayer,
                error: $error,
                selectedPlayerViewModel: $selectedPlayerViewModel
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
            playerArea: playerArea,
            center: {
                centerArea
            }
        )
    }

    func getCurrentPlayer(bottomPlayer: Player) -> some View {
        playerArea(player: bottomPlayer)
    }

    var body: some View {
        ZStack {
            Color.green
                .ignoresSafeArea()
            if let localPlayer = gameRunnerViewModel.players.getPlayerByIndex(localPlayerIndex) {
                let bottomPlayerViewModel = PlayerViewModel(
                    player: localPlayer,
                    hand: gameRunnerViewModel.getHandByPlayer(localPlayer) ?? CardCollection()
                )
                VStack {
                    getNonPlayer(bottomPlayerViewModel: bottomPlayerViewModel)
                    Spacer()
                    getCurrentPlayer(bottomPlayer: localPlayer)
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
