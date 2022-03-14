//
//  Player.swift
//  CardBox
//
//  Created by mactest on 10/03/2022.
//

typealias PlayerPlayCondition = (_ gameRunner: GameRunnerReadOnly, _ cards: [Card], _ player: Player) -> Bool

class Player: Identifiable {
    private(set) var hand: CardCollection
    private(set) var name: String
    private(set) var isOutOfGame = false

    private(set) var cardsPlayed = 0

    private var canPlayConditions: [PlayerPlayCondition]

    var description: String {
        name
    }

    init(name: String) {
        self.hand = CardCollection()
        self.name = name

        self.canPlayConditions = []
    }

    func addCard(_ card: Card) {
        self.hand.addCard(card)
    }

    func removeCard(_ card: Card) {
        self.hand.removeCard(card)
    }

    func getHand() -> CardCollection {
        self.hand
    }

    func hasCard(_ card: Card) -> Bool {
        hand.containsCard(card)
    }

    func hasCard(where predicate: (Card) -> Bool) -> Bool {
        hand.containsCard(where: predicate)
    }

    func addCanPlayCondition(_ condition: @escaping PlayerPlayCondition) {
        self.canPlayConditions.append(condition)
    }

    func canPlay(cards: [Card], gameRunner: GameRunnerReadOnly) -> Bool {
        canPlayConditions.allSatisfy({ $0(gameRunner, cards, self) })
    }

    func playCards(_ cards: [Card], gameRunner: GameRunnerReadOnly, on target: GameplayTarget) {
        let action = PlayCardAction(player: self, cards: cards, target: target)
        ActionDispatcher.runAction(action, on: gameRunner)
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
