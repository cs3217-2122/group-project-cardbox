//
//  CardPreviewView.swift
//  CardBox
//
//  Created by Stuart Long on 19/3/22.
//

import SwiftUI

struct CardPreviewView: View {
    @EnvironmentObject private var gameRunnerDelegate: GameRunnerDelegate
    var gameRunnerViewModel: GameRunnerProtocol {
        gameRunnerDelegate.runner
    }

    var body: some View {
        if let cardPreview = gameRunnerViewModel.cardPreview {
            CardView(card: cardPreview, isFaceUp: true, isSelected: false)
                .scaleEffect(1.5)
        }
    }
}
