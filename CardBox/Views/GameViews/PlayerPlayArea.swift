//
//  PlayerPlayArea.swift
//  CardBox
//
//  Created by Bernard Wan on 2/4/22.
//

import SwiftUI

struct PlayerPlayArea: View {
    var playerViewModel: PlayerViewModel
    let playerPlayAreaViewModel: PlayerPlayAreaViewModel
    @EnvironmentObject private var gameRunnerViewModel: ExplodingKittensGameRunner // MonopolyDeal
    @Binding var error: Bool
    let handWidth = 600

    var spacing: Double {
        let size = playerPlayAreaViewModel.size
        guard size > 0 else {
            return 0
        }
        return Double((handWidth - size * CardView.defaultCardWidth) / size)
    }

    var body: some View {
        HStack(spacing: CGFloat(spacing)) {
            ForEach(playerPlayAreaViewModel.sets) { cardSet in
                let cardSetViewModel =
                CardSetViewModel(cards: cardSet, isPlayDeck: true, gameRunner: gameRunnerViewModel)
                CardSetView(playerViewModel: playerViewModel, cardSetViewModel: cardSetViewModel, error: $error)

            }
        }
    }
}
