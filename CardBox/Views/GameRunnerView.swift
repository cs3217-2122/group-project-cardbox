//
//  GameRunnerView.swift
//  CardBox
//
//  Created by mactest on 12/03/2022.
//

import SwiftUI

struct GameRunnerView: View {

    @StateObject var gameRunnerViewModel = ExplodingKittensGameRunnerInitialiser.getAndSetupGameRunnerInstance()

    var body: some View {
        ZStack {
            Color.green
                .ignoresSafeArea()
            VStack {
                NonCurrentPlayerView()

                Spacer()

                CurrentPlayerView()
            }
            if let cardPreview = gameRunnerViewModel.cardPreview {
                CardView(cardViewModel: CardViewModel(card: cardPreview, isFaceUp: true))
            }
        }.environmentObject(gameRunnerViewModel)
    }
}
