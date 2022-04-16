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
    @State var selectedCardSetViewModel: CardSetViewModel?
    @State var cardPreview: Card?

    @ViewBuilder
    var centerArea: some View {
        HStack {
            DeckView(
                deck: gameRunnerViewModel.deck, gameRunner: gameRunnerViewModel
            )
            DeckView(
                deck: gameRunnerViewModel.gameplayArea, gameRunner: gameRunnerViewModel
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
                                 selectedPlayerViewModel: $selectedPlayerViewModel)
            PlayerHandView(player: player, hand: gameRunnerViewModel.getHandByPlayer(player),
                           bottomPlayer: player, error: $error)
            .border(Color.red)
        }

    }

    @ViewBuilder
    func otherPlayerArea(player: Player, rotateBy: Double) -> some View {
        MDPlayerPlayAreaView(player: player,
                             sets: gameRunnerViewModel.getPropertyAreaByPlayer(player),
                             rotateBy: rotateBy,
                             error: $error,
                             selectedCardSetViewModel: $selectedCardSetViewModel,
                             selectedPlayerViewModel: $selectedPlayerViewModel)
    }

    func getNonCurrentPlayer(bottomPlayer: Player) -> some View {
        NonBottomPlayerView(
            bottomPlayer: bottomPlayer,
            selectedPlayerViewModel: $selectedPlayerViewModel,
            selectedCardSetViewModel: .constant(nil),
            error: $error,
            playerArea: otherPlayerArea,
            center: {
                centerArea
            }
        )
    }

    func getCurrentPlayer(bottomPlayer: Player) -> some View {
        bottomPlayerArea(player: bottomPlayer)
    }
    var body: some View {
        ZStack {
            Color.green
                .ignoresSafeArea()
            if let currentPlayer = gameRunnerViewModel.gameState.players.currentPlayer {
                VStack {
                    getNonCurrentPlayer(bottomPlayer: currentPlayer)
                    Spacer()
                    getCurrentPlayer(bottomPlayer: currentPlayer)
                }
            }
            CardPreviewView()

            if let request = gameRunnerViewModel.gameState.globalRequests.first {
                RequestViewFactory(request: request, isOnline: false)
            }

            WinMessageView()
        }
        .environmentObject(GameRunnerDelegate(runner: gameRunnerViewModel))
        .onAppear(perform: setup)
    }

    private func setup() {
        gameRunnerViewModel.setup()
    }

}
