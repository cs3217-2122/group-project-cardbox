//
//  PlayerPlayAreaViewModel.swift
//  CardBox
//
//  Created by Bernard Wan on 2/4/22.
//

import SwiftUI

class PlayerPlayAreaViewModel: ObservableObject {
    var player: Player
    var sets: MonopolyDealPlayerPropertyArea
    var gameRunner: MonopolyDealGameRunner

    init(player: Player, sets: MonopolyDealPlayerPropertyArea, gameRunner: MonopolyDealGameRunner) {
        self.player = player
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
        guard self.player.id == player.id else {
            return false
        }
        guard let card = selectedCards[0] as? PropertyCard else {
            return false
        }

        guard sets.canAdd(card) else {
            return false
        }

        let playerHand = gameRunner.getHandByPlayer(player)
        playerHand.removeCard(card)

        if let player = player as? MonopolyDealPlayer {
            if let propertySet = player.getPlayArea(gameRunner: gameRunner)?
                .getPropertySet(from: selectedCards[0]) {
                propertySet.removeCard(card)
            }
            sets.addPropertyCard(card)
            gameRunner.executeGameEvents([IncrementPlayerPlayCountEvent(player: player)])
        }
        return true
    }
}
