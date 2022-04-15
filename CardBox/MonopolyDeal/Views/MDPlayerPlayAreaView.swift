//
//  MDNonPlayerView.swift
//  CardBox
//
//  Created by user213938 on 4/6/22.
//

import SwiftUI

struct MDPlayerPlayAreaView: View {
    var player: Player
    let playerViewModel: PlayerViewModel
    let playerPlayAreaViewModel: PlayerPlayAreaViewModel
    @Binding var selectedCardSetViewModel: CardSetViewModel?
    @Binding var selectedPlayerViewModel: PlayerViewModel?
    @EnvironmentObject private var gameRunnerDelegate: GameRunnerDelegate
    var gameRunnerViewModel: MonopolyDealGameRunnerProtocol? {
        gameRunnerDelegate.runner as? MonopolyDealGameRunnerProtocol
    }

    @Binding var error: Bool
    let handWidth = 600

    init(player: Player, sets: MonopolyDealPlayerPropertyArea,
         error: Binding<Bool>, selectedCardSetViewModel: Binding<CardSetViewModel?>,
         selectedPlayerViewModel: Binding<PlayerViewModel?>) {
        self.player = player
        self.playerViewModel = PlayerViewModel(player: player, hand: CardCollection())
        self.playerPlayAreaViewModel = PlayerPlayAreaViewModel(sets: sets)
        self._error = error
        self._selectedCardSetViewModel = selectedCardSetViewModel
        self._selectedPlayerViewModel = selectedPlayerViewModel
    }

    var spacing: Double {
        let size = playerPlayAreaViewModel.size
        guard size > 0 else {
            return 0
        }
        return Double((handWidth - size * Int((gameRunnerViewModel?.cardWidth ?? 75))) / size)
    }

    var playerText: String {
        var playerName = player.name
        if player.isOutOfGame {
            playerName += "(Dead)"
        }
        if player === gameRunnerViewModel?.players.currentPlayer {
            playerName = "Current Player: " + playerName
        }
        return playerName
    }

    var nameButton: some View {
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
                    .foregroundColor(selectedPlayerViewModel.player === player
                                     ? Color.red : Color.blue)
            } else {
                Text(playerText)
            }

        }
    }

    var properties: some View {
        ZStack {
            Rectangle()
                .fill(Color.clear)
                .border(Color.black)
                .frame(width: CGFloat(handWidth), height: gameRunnerViewModel?.cardHeight)
            HStack(spacing: CGFloat(spacing)) {
                ForEach(playerPlayAreaViewModel.sets.getArea()) { cardSet in
                    CardSetView(
                        player: player,
                        cards: cardSet,
                        selectedCardSetViewModel: $selectedCardSetViewModel,
                        error: $error
                    )
                }
            }
        }
    }

    var body: some View {
        VStack {
            nameButton
            HStack {
                if let mdViewModel = gameRunnerViewModel {
                    // Money Pile
                    DeckView(
                        deck: mdViewModel.getMoneyAreaByPlayer(player),
                        gameRunner: gameRunnerViewModel ?? MonopolyDealGameRunner()
                    )
                    properties

                }
            }
        }
    }
}
