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
                deck: gameRunnerViewModel.deck, isPlayDeck: true, gameRunner: gameRunnerViewModel
            )
            DeckView(
                deck: gameRunnerViewModel.gameplayArea, isPlayDeck: true, gameRunner: gameRunnerViewModel
            )
        }
    }

    @ViewBuilder
    func playerArea(player: Player, rotateBy: Double) -> some View {
        if let bottomPlayer = gameRunnerViewModel.gameState.players.getPlayerByIndex(localPlayerIndex) {
            EKPlayerView(
                player: player,
                hand: gameRunnerViewModel.getHandByPlayer(player),
                bottomPlayer: bottomPlayer,
                rotateBy: rotateBy,
                error: $error,
                selectedPlayerViewModel: $selectedPlayerViewModel
            )
        }
    }

    func getNonPlayer(bottomPlayer: Player) -> some View {
        NonPlayerView(
            bottomPlayer: bottomPlayer,
            selectedPlayerViewModel: $selectedPlayerViewModel,
            selectedCardSetViewModel: .constant(nil),
            localPlayerIndex: localPlayerIndex,
            error: $error,
            playerArea: playerArea,
            center: {
                centerArea
            }
        )
    }

    func getCurrentPlayer(bottomPlayer: Player) -> some View {
        playerArea(player: bottomPlayer, rotateBy: 0.0)
    }

    var body: some View {
        ZStack {
            Color.green
                .ignoresSafeArea()

            if let localPlayer = gameRunnerViewModel.gameState.players.getPlayerByIndex(localPlayerIndex) {

                VStack {
                    getNonPlayer(bottomPlayer: localPlayer)
                    Spacer()
                    getCurrentPlayer(bottomPlayer: localPlayer)
                }
            }
            CardPreviewView()

            if let localPlayer = gameRunnerViewModel.gameState.players.getPlayerByIndex(localPlayerIndex),
               let request = gameRunnerViewModel.gameState.globalRequests.first {
                if request.toPlayer.id == localPlayer.id {
                    RequestViewFactory(request: request, isOnline: true)
                } else {
                    WaitingForResponseView()
                }
            }

            WinMessageView()
        }
        .sheet(isPresented: $gameRunnerViewModel.isShowingPeek, onDismiss: dismissPeek) {
            PeekCardsView(cards: gameRunnerViewModel.cardsPeeking)
        }
        .environmentObject(GameRunnerDelegate(runner: gameRunnerViewModel))
    }

    private func setup() {
//        gameRunnerViewModel.initialiseFrom(explodingKittensGameRunnerInitialiser)
    }

    func dismissPeek() {
        gameRunnerViewModel.isShowingPeek = false
    }
}
