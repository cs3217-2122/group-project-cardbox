//
//  MDNonPlayerView.swift
//  CardBox
//
//  Created by user213938 on 4/6/22.
//

import SwiftUI

struct MDPlayerPlayAreaView: View {
    var playerViewModel: PlayerViewModel
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
                    ForEach(playerPlayAreaViewModel.sets.getArea()) { cardSet in
                        CardSetView(
                            player: playerViewModel.player,
                            cards: cardSet,
                            selectedCardSetViewModel: $selectedCardSetViewModel,
                            error: $error
                        )
                    }
                    DeckView(
                        deck: mdViewModel.getMoneyAreaByPlayer(playerViewModel.player),
                        gameRunner: gameRunnerViewModel ?? MonopolyDealGameRunner()
                    )
                }
            }
        }
    }
}
