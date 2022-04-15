//
//  PlayerHandView.swift
//  CardBox
//
//  Created by Bernard Wan on 14/3/22.
//

import SwiftUI

struct PlayerHandView: View {
    var playerViewModel: PlayerViewModel
    var bottomPlayer: Player
    @EnvironmentObject private var gameRunnerDelegate: GameRunnerDelegate
    var gameRunnerViewModel: GameRunnerProtocol {
        gameRunnerDelegate.runner
    }

    @Binding var error: Bool
    let handWidth = 600

    init(player: Player, hand: CardCollection, bottomPlayer: Player, error: Binding<Bool>) {
        playerViewModel = PlayerViewModel(player: player,
                                          hand: hand)
        self.bottomPlayer = bottomPlayer
        self._error = error
    }

    var spacing: Double {
        let size = playerViewModel.handSize
        guard size > 0 else {
            return 0
        }
        return Double((handWidth - size * CardView.defaultCardWidth) / size)
    }

    var isFaceUp: Bool {
        bottomPlayer.id == playerViewModel.player.id
    }

    var handView: some View {
        HStack(spacing: CGFloat(spacing)) {
            ForEach(playerViewModel.getCards()) { card in
                let isSelected = playerViewModel.isSelected(card: card, gameRunner: gameRunnerViewModel)
                if isFaceUp {
                    CardView(card: card, isFaceUp: isFaceUp, isSelected: isSelected,
                             player: playerViewModel.player, bottomPlayer: bottomPlayer)
                    .onTapGesture {
                        if playerViewModel.isCurrentPlayer(gameRunner: gameRunnerViewModel) {
                            playerViewModel
                                .tapCard(card: card, gameRunner: gameRunnerViewModel)
                            error = !playerViewModel.canPlayCard(gameRunner: gameRunnerViewModel)
                        }
                    }
                    .gesture(
                        DragGesture(minimumDistance: 0.0)
                            .onChanged { _ in
                                playerViewModel.previewCard(card: card, gameRunner: gameRunnerViewModel)
                            }
                            .onEnded { _ in
                                playerViewModel.unpreviewCard(card: card, gameRunner: gameRunnerViewModel)
                            }
                    )
                } else {
                    CardView(card: card, isFaceUp: isFaceUp, isSelected: isSelected,
                             player: playerViewModel.player, bottomPlayer: bottomPlayer)
                }
            }
        }
    }

    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.clear)
                .frame(width: CGFloat(handWidth), height: 250)
            handView
        }
    }
}
