//
//  CardSetViewModel.swift
//  CardBox
//
//  Created by Bernard Wan on 2/4/22.
//

import SwiftUI

class CardSetViewModel: ObservableObject {
    var player: Player
    var cards: CardCollection
    var isPlayDeck: Bool
    var gameRunner: GameRunnerProtocol

    init(player: Player, cards: CardCollection, isPlayDeck: Bool, gameRunner: GameRunnerProtocol) {
        self.player = player
        self.cards = cards
        self.isPlayDeck = isPlayDeck
        self.gameRunner = gameRunner
    }

    func getCards() -> [Card] {
        cards.getCards()
    }

    var topCard: Card? {
        cards.topCard
    }

    var size: Int {
        cards.count
    }

    func addCards() {
        let selectedCards = gameRunner.cardsDragging
        let players = gameRunner.gameState.players
        guard (players.currentPlayer as? ExplodingKittensPlayer) != nil else {
            return
        }

        if selectedCards.count == 1 {
            // TODO: Implement checking and adding cards to sets
        }
    }
}

extension CardSetViewModel: DropDelegate {
    func performDrop(info: DropInfo) -> Bool {
        let selectedCards = gameRunner.cardsDragging
        let players = gameRunner.gameState.players
        guard let player = players.currentPlayer else {
            return false
        }
        guard self.player.id == player.id else {
            return false
        }


        if cards.canAdd(selectedCards[0]) {
            let playerHand = gameRunner.getHandByPlayer(player)

            // if in hand move from hand to set
            // if in set, move from set to set
            if let player = player as? MonopolyDealPlayer {
                gameRunner.executeGameEvents([
                    MoveCardsDeckToDeckEvent(cards: selectedCards, fromDeck: playerHand, toDeck: cards),
                    IncrementPlayerPlayCountEvent(player: player)])
            }
        }
        return true
    }
}
