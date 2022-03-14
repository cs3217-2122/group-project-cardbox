//
//  GameRunnerView.swift
//  CardBox
//
//  Created by mactest on 12/03/2022.
//

import SwiftUI

struct GameRunnerView: View {
    let viewModel = GameRunnerViewModel()

    var body: some View {
        deck
        player
    }

    var deck: some View {
        ForEach(viewModel.gameRunner.deck.getCards()) { card in
            CardView(card: card)
        }
    }

    var player: some View {
        HStack {
            ForEach(viewModel.gameRunner.players.getPlayers()) { player in
                PlayerView(player: player)
            }
        }
    }
}
