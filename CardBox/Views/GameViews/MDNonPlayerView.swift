//
//  MDNonPlayerView.swift
//  CardBox
//
//  Created by user213938 on 4/6/22.
//

import SwiftUI

struct MDNonPlayerView: View {
    var playerViewModel: PlayerViewModel
    let playerPlayAreaViewModel: PlayerPlayAreaViewModel
    @Binding var selectedCardSetViewModel: CardSetViewModel?
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
                if let mdViewModel = gameRunnerViewModel {
                    // Money Pile
                    // DeckView(deckViewModel: , isFaceUp: true)
                    ForEach(playerPlayAreaViewModel.sets.area) { cardSet in
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
                        deckViewModel: DeckViewModel(
                            deck: mdViewModel.getMoneyAreaByPlayer(playerViewModel.player),
                            isPlayDeck: false,
                            gameRunner: mdViewModel
                        ),
                        isFaceUp: true
                    )
                }
            }
        }
    }
}
