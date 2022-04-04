//
//  PlayerPlayArea.swift
//  CardBox
//
//  Created by Bernard Wan on 2/4/22.
//

import SwiftUI

struct MDPlayerView: View {
    var playerViewModel: PlayerViewModel
    var currentPlayerViewModel: PlayerViewModel
    let playerPlayAreaViewModel: PlayerPlayAreaViewModel
    @EnvironmentObject private var gameRunnerDelegate: GameRunnerDelegate
    var gameRunnerViewModel: MonopolyDealGameRunnerProtocol? {
        gameRunnerDelegate.runner as? MonopolyDealGameRunnerProtocol
    }

    @Binding var error: Bool
    let handWidth = 600

    var playerText: String {
        var playerName = playerViewModel.player.name
        if playerViewModel.player.isOutOfGame {
            playerName += "(Dead)"
        }
        if playerViewModel.player === gameRunnerViewModel?.players.currentPlayer {
            playerName = "Current Player: " + playerName
        }
        return playerName
    }

    var spacing: Double {
        let size = playerPlayAreaViewModel.size
        guard size > 0 else {
            return 0
        }
        return Double((handWidth - size * CardView.defaultCardWidth) / size)
    }

    var body: some View {
        VStack {
            HStack(spacing: CGFloat(spacing)) {
                // Money Pile
                // DeckView(deckViewModel: , isFaceUp: true)
                ForEach(playerPlayAreaViewModel.sets) { cardSet in
                    if let mdViewModel = gameRunnerViewModel {
                        let cardSetViewModel =
                        CardSetViewModel(cards: cardSet, isPlayDeck: true, gameRunner: mdViewModel)
                        CardSetView(playerViewModel: playerViewModel, cardSetViewModel: cardSetViewModel, error: $error)
                    }
                }
            }
            PlayerHandView(playerViewModel: playerViewModel,
                           bottomPlayerViewModel: currentPlayerViewModel,
                           playerHandViewModel: PlayerHandViewModel(hand: playerViewModel.hand),
                           error: $error)
        }
    }
}
