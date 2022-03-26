//
//  Player.swift
//  CardBox
//
//  Created by mactest on 10/03/2022.
//

typealias CardCombo = (_ cards: [Card]) -> [CardAction]

class Player: Identifiable {
    private(set) var hand: CardCollection
    private(set) var name: String
    private(set) var isOutOfGame = false

    private(set) var cardsPlayed = 0

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

    func getCard(where predicate: (Card) -> Bool) -> Card? {
        self.hand.getCard(where: predicate)
    }

    // To be overwritten
    func canPlay(cards: [Card], gameRunner: GameRunnerReadOnly) -> Bool {
        true
    }

    // To be overwritten
    func playCards(_ cards: [Card], gameRunner: GameRunnerReadOnly, on target: GameplayTarget) {
        // TODO: Add play card action
    }

    func endTurn(gameRunner: GameRunnerReadOnly) {
        guard !isOutOfGame else {
            return
        }

        // TODO: Add end turn action
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

    func incrementCardsPlayed() {
        self.cardsPlayed += 1
    }

    func resetCardsPlayed() {
        self.cardsPlayed = 0
    }
}
