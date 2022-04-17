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

    var rotateBy = 0.0
    @Binding var error: Bool
    static let handWidth = 600

    init(player: Player, sets: MonopolyDealPlayerPropertyArea, rotateBy: Double,
         error: Binding<Bool>, selectedCardSetViewModel: Binding<CardSetViewModel?>,
         selectedPlayerViewModel: Binding<PlayerViewModel?>, gameRunner: MonopolyDealGameRunner) {
        self.player = player
        self.playerViewModel = PlayerViewModel(player: player, hand: CardCollection())
        self.playerPlayAreaViewModel = PlayerPlayAreaViewModel(player: player, sets: sets, gameRunner: gameRunner)
        self.rotateBy = rotateBy
        self._error = error
        self._selectedCardSetViewModel = selectedCardSetViewModel
        self._selectedPlayerViewModel = selectedPlayerViewModel
    }

    var spacing: Double {
        let size = playerPlayAreaViewModel.size
        guard size > 0 else {
            return 0
        }
        return Double((MDPlayerPlayAreaView.handWidth - size * Int((gameRunnerViewModel?.cardWidth ?? 75))) / size)
    }

    var cardHeight: CGFloat {
        CGFloat(gameRunnerViewModel?.cardHeight ?? 150)
    }

    var frameWidth: CGFloat {
        if rotateBy == 90 || rotateBy == -90 {
            return CGFloat((gameRunnerViewModel?.cardHeight ?? 250) + 30)
        } else {
            return CGFloat(PlayerHandView.handWidth)
        }
    }

    var frameHeight: CGFloat {
        if rotateBy == 90 || rotateBy == -90 {
            return CGFloat(PlayerHandView.handWidth)
        } else {
            return CGFloat((gameRunnerViewModel?.cardHeight ?? 250) + 30)
        }
    }

    var playerText: String {
        var playerName = player.name
        if player.isOutOfGame {
            playerName += "(Dead)"
        }
        if player === gameRunnerViewModel?.gameState.players.currentPlayer {
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
                .fill(Color.green)
                .border(Color.black)
                .frame(width: CGFloat(MDPlayerPlayAreaView.handWidth), height: cardHeight)
                .onDrop(of: ["cardbox.card"], delegate: playerPlayAreaViewModel)

            HStack(spacing: CGFloat(spacing)) {
                ForEach(playerPlayAreaViewModel.sets.getArea()) { cardSet in
                    CardSetView(
                        player: player,
                        cards: cardSet,
                        selectedCardSetViewModel: $selectedCardSetViewModel,
                        error: $error,
                        gameRunner: gameRunnerViewModel ?? MonopolyDealGameRunner()
                    )
                    .border(Color.teal)
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
                        isPlayDeck: false,
                        gameRunner: gameRunnerViewModel ?? MonopolyDealGameRunner()
                    )
                    properties

                }
            }
        }
        .rotationEffect(Angle(degrees: rotateBy))
        .fixedSize()
        .frame(width: frameWidth, height: frameHeight)
    }
}
