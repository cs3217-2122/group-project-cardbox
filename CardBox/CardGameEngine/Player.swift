//
//  Player.swift
//  CardBox
//
//  Created by mactest on 10/03/2022.
//

class Player: Identifiable {
    private(set) var hand: CardCollection
    private(set) var name: String
    private(set) var isOutOfGame = false

    var description: String {
        name
    }

    init(name: String) {
        self.hand = CardCollection()
        self.name = name
    }

    func addCard(_ card: Card) {
        guard !isOutOfGame else {
            return
        }

        self.hand.addCard(card)
    }

    func removeCard(_ card: Card) {
        guard !isOutOfGame else {
            return
        }

        self.hand.removeCard(card)
    }

    func getHand() -> CardCollection {
        self.hand
    }

    func hasCard(_ card: Card) -> Bool {
        guard !isOutOfGame else {
            return false
        }

        return hand.containsCard(card)
    }

    func hasCard(where predicate: (Card) -> Bool) -> Bool {
        guard !isOutOfGame else {
            return false
        }

        return hand.containsCard(where: predicate)
    }

    func playCard(_ card: Card, gameRunner: GameRunnerReadOnly, on target: GameplayTarget) {
    }

    func endTurn(gameRunner: GameRunnerReadOnly) {
        guard !isOutOfGame else {
            return
        }

        ActionDispatcher.runAction(EndTurnAction(), on: gameRunner)
    }

    func getCardByIndex(_ index: Int) -> Card? {
        guard !isOutOfGame else {
            return nil
        }

        return hand.getCardByIndex(index)
    }
    
    func setOutOfGame(_ outOfGame: Bool) {
        self.isOutOfGame = outOfGame
    }
}
