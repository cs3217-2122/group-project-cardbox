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
        let players = gameRunner.players
        guard let player = players.currentPlayer as? ExplodingKittensPlayer else {
            return
        }

        if selectedCards.count == 1 {
            // TODO: Implement checking and adding cards to sets
        }
    }
}

extension CardSetViewModel: DropDelegate {
    func performDrop(info: DropInfo) -> Bool {
        addCards()
        return true
    }
}
