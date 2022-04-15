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
    @Binding var selectedCardSetViewModel: CardSetViewModel?
    @EnvironmentObject private var gameRunnerDelegate: GameRunnerDelegate
    var gameRunnerViewModel: MonopolyDealGameRunnerProtocol? {
        gameRunnerDelegate.runner as? MonopolyDealGameRunnerProtocol
    }

    @Binding var error: Bool
    let handWidth = 300

    var playerText: String {
        var playerName = playerViewModel.player.name
        if playerViewModel.player.isOutOfGame {
            playerName += "(Dead)"
        }
        if playerViewModel.player === gameRunnerViewModel?.gameState.players.currentPlayer {
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
                if let mdViewModel = gameRunnerViewModel {
                    // Money Pile
                    // DeckView(deckViewModel: , isFaceUp: true)
                    ForEach(playerPlayAreaViewModel.sets.getArea()) { cardSet in
                        let cardSetViewModel =
                        CardSetViewModel(cards: cardSet, isPlayDeck: true, gameRunner: mdViewModel)
                        CardSetView(
                            playerViewModel: playerViewModel,
                            cardSetViewModel: cardSetViewModel,
                            selectedCardSetViewModel: $selectedCardSetViewModel,
                            error: $error
                        )
                    }
                    DeckView(
                        deck: mdViewModel.getMoneyAreaByPlayer(playerViewModel.player)
                    )
                }
            }
            PlayerHandView(player: playerViewModel.player,
                           hand: playerViewModel.hand,
                           bottomPlayer: currentPlayerViewModel.player,
                           error: $error)
        }
    }
}
