//
//  CardSetViewModel.swift
//  CardBox
//
//  Created by Bernard Wan on 2/4/22.
//

import SwiftUI

class CardSetViewModel: ObservableObject {
    var cards: CardCollection
    var isPlayDeck: Bool
    var gameRunner: GameRunnerProtocol

    init(cards: CardCollection, isPlayDeck: Bool, gameRunner: GameRunnerProtocol) {
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

        if cards.canAdd(selectedCards[0]) {
            cards.addCard(selectedCards[0])
            let playerHand = gameRunner.getHandByPlayer(player)
            playerHand.removeCard(selectedCards[0])
            if let player = player as? MonopolyDealPlayer {
                gameRunner.executeGameEvents([IncrementPlayerPlayCountEvent(player: player)])
            }
        }
        return true
    }
}
