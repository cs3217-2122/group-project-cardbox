//
//  GameRunnerView.swift
//  CardBox
//
//  Created by mactest on 12/03/2022.
//

import SwiftUI

struct GameRunnerView: View {
    @StateObject var viewModel = ExplodingKittensGameRunnerInitialiser.getAndSetupGameRunnerInstance()

    var body: some View {
        deck
        player
    }

    var deck: some View {
        ForEach(viewModel.deck.getCards()) { card in
            CardView(card: card)
        }
    }

    var player: some View {
        HStack {
            ForEach(viewModel.players.getPlayers()) { player in
                PlayerView(player: player, gameRunner: viewModel)
            }
        }
    }
}
