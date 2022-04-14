//
//  PlayerHandView.swift
//  CardBox
//
//  Created by Bernard Wan on 14/3/22.
//

import SwiftUI

struct PlayerHandView: View {
    var playerViewModel: PlayerViewModel
    var bottomPlayerViewModel: PlayerViewModel
    let playerHandViewModel: PlayerHandViewModel
    @EnvironmentObject private var gameRunnerDelegate: GameRunnerDelegate
    var gameRunnerViewModel: GameRunnerProtocol {
        gameRunnerDelegate.runner
    }

    @Binding var error: Bool
    let handWidth = 600

    var spacing: Double {
        let size = playerHandViewModel.handSize
        guard size > 0 else {
            return 0
        }
        return Double((handWidth - size * CardView.defaultCardWidth) / size)
    }

    var isFaceUp: Bool {
        bottomPlayerViewModel.player.id == playerViewModel.player.id
    }

    var body: some View {
        HStack(spacing: CGFloat(spacing)) {
            ForEach(playerHandViewModel.getCards()) { card in
                let isSelected = playerViewModel.isSelected(card: card, gameRunner: gameRunnerViewModel)
                if isFaceUp {
                    CardView(card: card, isFaceUp: isFaceUp, isSelected: isSelected,
                             bottomPlayer: bottomPlayerViewModel.player)
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
                             bottomPlayer: bottomPlayerViewModel.player)
                }
            }
        }
    }
}
