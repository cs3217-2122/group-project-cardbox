//
//  PlayerPlayArea.swift
//  CardBox
//
//  Created by Bernard Wan on 2/4/22.
//

import SwiftUI

struct MDPlayerView: View {
    var playerViewModel: PlayerViewModel
    var bottomPlayer: Player
    let playerPlayAreaViewModel: PlayerPlayAreaViewModel
    @Binding var selectedCardSetViewModel: CardSetViewModel?
    @Binding var selectedPlayerViewModel: PlayerViewModel?
    @EnvironmentObject private var gameRunnerDelegate: GameRunnerDelegate
    var gameRunnerViewModel: MonopolyDealGameRunnerProtocol? {
        gameRunnerDelegate.runner as? MonopolyDealGameRunnerProtocol
    }

    @Binding var error: Bool
    let handWidth = 300

    init(player: Player, hand: CardCollection, sets: MonopolyDealPlayerPropertyArea,
         bottomPlayer: Player, error: Binding<Bool>,
         selectedPlayerViewModel: Binding<PlayerViewModel?>,
         selectedCardSetViewModel: Binding<CardSetViewModel?>) {
        playerViewModel = PlayerViewModel(player: player,
                                          hand: hand)
        playerPlayAreaViewModel = PlayerPlayAreaViewModel(sets: sets)
        self.bottomPlayer = bottomPlayer
        self._error = error
        self._selectedPlayerViewModel = selectedPlayerViewModel
        self._selectedCardSetViewModel = selectedCardSetViewModel
    }

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
            Button {
                guard let mdRunner = self.gameRunnerViewModel else {
                    return
                }
                if !playerViewModel.isCurrentPlayer(gameRunner: mdRunner) {
                    if !playerViewModel.isDead() {
                        selectedPlayerViewModel = playerViewModel
                    }
                }
            } label: {
                if let selectedPlayerViewModel = selectedPlayerViewModel {
                    Text(playerText)
                        .foregroundColor(selectedPlayerViewModel.player === playerViewModel.player
                                         ? Color.red : Color.blue)
                } else {
                    Text(playerText)
                }

            }

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
                           bottomPlayer: bottomPlayer,
                           error: $error)
        }
    }
}
