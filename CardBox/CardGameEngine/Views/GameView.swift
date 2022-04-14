//
//  GameRunnerView.swift
//  CardBox
//
//  Created by mactest on 12/03/2022.
//

import SwiftUI

struct GameView<PlayerView: View, CentreView: View>: View {
    @StateObject var gameRunnerViewModel: GameRunnerProtocol
    @State var error = true
    @State var selectedPlayerViewModel: PlayerViewModel?
    @State var cardPreview: Card?
    let centerArea: () -> CentreView

    func getNonCurrentPlayer(bottomPlayerViewModel: PlayerViewModel) -> some View {
        NonBottomPlayerView(
            error: $error,
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
            if let currentPlayer = gameRunnerViewModel.players.currentPlayer {
                let bottomPlayerViewModel = PlayerViewModel(
                    player: currentPlayer,
                    hand: gameRunnerViewModel.getHandByPlayer(currentPlayer) ?? CardCollection()
                )
                VStack {
                    getNonCurrentPlayer(bottomPlayerViewModel: bottomPlayerViewModel)
                    Spacer()
                    getCurrentPlayer(bottomPlayerViewModel: bottomPlayerViewModel)
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
