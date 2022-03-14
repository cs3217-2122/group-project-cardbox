//
//  CardViewModel.swift
//  CardBox
//
//  Created by mactest on 13/03/2022.
//

import SwiftUI

class CardViewModel: ObservableObject {
    var card: Card
    let player: Player
    let gameRunner: GameRunnerReadOnly

    init(card: Card, player: Player, gameRunner: GameRunnerReadOnly) {
        self.card = card
        self.player = player
        self.gameRunner = gameRunner
    }

    func playCard() {
        player.playCards([card], gameRunner: gameRunner, on: .none)
    }
}
