//
//  PlayerPlayAreaViewModel.swift
//  CardBox
//
//  Created by Bernard Wan on 2/4/22.
//

import SwiftUI

class PlayerPlayAreaViewModel: ObservableObject {
    var sets: MonopolyDealPlayerPropertyArea
    var gameRunner: MonopolyDealGameRunner

    init(sets: MonopolyDealPlayerPropertyArea, gameRunner: MonopolyDealGameRunner) {
        self.sets = sets
        self.gameRunner = gameRunner
    }

    var size: Int {
        sets.count
    }

}

extension PlayerPlayAreaViewModel: DropDelegate {
    func performDrop(info: DropInfo) -> Bool {
        let selectedCards = gameRunner.cardsDragging
        let players = gameRunner.gameState.players
        guard let player = players.currentPlayer else {
            return false
        }

        if sets.canAdd(selectedCards[0]) {
            sets.addPropertyCard(selectedCards[0])
            let playerHand = gameRunner.getHandByPlayer(player)
            playerHand.removeCard(selectedCards[0])
            if let player = player as? MonopolyDealPlayer {
                gameRunner.executeGameEvents([IncrementPlayerPlayCountEvent(player: player)])
            }
        }
        return true
    }
}
