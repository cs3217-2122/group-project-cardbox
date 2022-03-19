//
//  PlayerHandView.swift
//  CardBox
//
//  Created by Bernard Wan on 14/3/22.
//

import SwiftUI

struct PlayerHandView: View {
    var playerViewModel: PlayerViewModel
    let playerHandViewModel: PlayerHandViewModel
    @EnvironmentObject private var gameRunnerViewModel: GameRunner
    @Binding var error: Bool
    let handWidth = 800
    
    var spacing: Double {
        let size = playerHandViewModel.getSize()
        // availableSpace - size * cardWidth / size
        // TODO: figure out spacing
        return Double((handWidth - size * CardView.defaultCardWidth) / size)
    }

    var body: some View {
        HStack(spacing: CGFloat(spacing)) {
            ForEach(playerHandViewModel.getCards()) { card in
                let cardViewModel = CardViewModel(card: card,
                                                  isFaceUp: playerViewModel
                                                    .isCurrentPlayer(gameRunner: gameRunnerViewModel))
                CardView(cardViewModel: cardViewModel)
                    .onTapGesture {
                        if playerViewModel.isCurrentPlayer(gameRunner: gameRunnerViewModel) {
                            playerViewModel
                                .tapCard(card: card, cardViewModel: cardViewModel, gameRunner: gameRunnerViewModel)
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
            }
        }
    }
}

struct PlayerHandView_Previews: PreviewProvider {
    static var previews: some View {
        Text("stub")
    }
}
