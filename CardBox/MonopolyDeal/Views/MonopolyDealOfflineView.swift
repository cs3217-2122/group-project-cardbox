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
    func playerArea(player: Player) -> some View {
        if let bottomPlayer = gameRunnerViewModel.players.currentPlayer {
            MDPlayerView(player: player,
                         hand: gameRunnerViewModel.getHandByPlayer(player)
                         ?? CardCollection(),
                         sets: gameRunnerViewModel.getPropertyAreaByPlayer(player),
                         bottomPlayer: bottomPlayer,
                         error: $error,
                         selectedPlayerViewModel: $selectedPlayerViewModel,
                         selectedCardSetViewModel: $selectedCardSetViewModel)
        }
    }

    func getNonCurrentPlayer(bottomPlayer: Player) -> some View {
        NonBottomPlayerView(
            bottomPlayer: bottomPlayer,
            selectedPlayerViewModel: $selectedPlayerViewModel,
            selectedCardSetViewModel: .constant(nil),
            error: $error,
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
            if let currentPlayer = gameRunnerViewModel.players.currentPlayer {
                VStack {
                    getNonCurrentPlayer(bottomPlayer: currentPlayer)
                    Spacer()
                    getCurrentPlayer(bottomPlayer: currentPlayer)
                }
            }
            CardPreviewView()

            if let request = gameRunnerViewModel.globalRequests.first {
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
