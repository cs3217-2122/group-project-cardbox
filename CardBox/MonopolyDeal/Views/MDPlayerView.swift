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
        return Double((handWidth - size * Int((gameRunnerViewModel?.cardWidth ?? 75))) / size)
    }

    var name: some View {
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
    }

    var body: some View {
        VStack {
            name

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
                        isPlayDeck: false,
                        gameRunner: gameRunnerViewModel ?? MonopolyDealGameRunner()
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
