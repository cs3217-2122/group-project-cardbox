//
//  MonopolyDealOnlineView.swift
//  CardBox
//
//  Created by Bernard Wan on 18/4/22.
//

import SwiftUI

struct MonopolyDealOnlineView: View {
    @StateObject var gameRunnerViewModel: MonopolyDealGameRunner
    @State var error = true
    @State var selectedPlayerViewModel: PlayerViewModel?
    @State var selectedCardSetViewModel: CardSetViewModel?
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
    func bottomPlayerArea(player: Player) -> some View {
        VStack {
            MDPlayerPlayAreaView(player: player,
                                 sets: gameRunnerViewModel.getPropertyAreaByPlayer(player),
                                 rotateBy: 0.0,
                                 error: $error,
                                 selectedCardSetViewModel: $selectedCardSetViewModel,
                                 selectedPlayerViewModel: $selectedPlayerViewModel,
                                 gameRunner: gameRunnerViewModel)
            PlayerHandView(player: player, hand: gameRunnerViewModel.getHandByPlayer(player),
                           bottomPlayer: player, error: $error)
        }

    }

    @ViewBuilder
    func otherPlayerArea(player: Player, rotateBy: Double) -> some View {
        MDPlayerPlayAreaView(player: player,
                             sets: gameRunnerViewModel.getPropertyAreaByPlayer(player),
                             rotateBy: rotateBy,
                             error: $error,
                             selectedCardSetViewModel: $selectedCardSetViewModel,
                             selectedPlayerViewModel: $selectedPlayerViewModel,
                             gameRunner: gameRunnerViewModel)
    }

    func getNonCurrentPlayer(bottomPlayer: Player) -> some View {
        NonPlayerView(
            bottomPlayer: bottomPlayer,
            selectedPlayerViewModel: $selectedPlayerViewModel,
            selectedCardSetViewModel: .constant(nil),
            localPlayerIndex: localPlayerIndex,
            error: $error,
            playerArea: otherPlayerArea,
            center: {
                centerArea
            })
    }

    func getCurrentPlayer(bottomPlayer: Player) -> some View {
        bottomPlayerArea(player: bottomPlayer)
    }
    var body: some View {
        ZStack {
            Color.green
                .ignoresSafeArea()
            if let localPlayer = gameRunnerViewModel.gameState.players.getPlayerByIndex(localPlayerIndex) {
                VStack {
                    getNonCurrentPlayer(bottomPlayer: localPlayer)
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
                    NoInteractionOverlayView()
                }
            }

            WinMessageView()
            MessagesView()
        }
        .environmentObject(GameRunnerDelegate(runner: gameRunnerViewModel))
    }

    private func setup() {
        gameRunnerViewModel.setup()
    }

}
