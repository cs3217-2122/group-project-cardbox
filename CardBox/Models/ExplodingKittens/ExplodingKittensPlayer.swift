//
//  ExplodingKittensPlayer.swift
//  CardBox
//
//  Created by mactest on 25/03/2022.
//

class ExplodingKittensPlayer: Player {
    private(set) var attackCount = 0

    func incrementAttackCount() {
        self.attackCount += 1
    }

    func decrementAttackCount() {
        self.attackCount = max(0, self.attackCount - 1)
    }

    override func canPlay(cards: [Card], gameRunner: GameRunnerProtocol) -> Bool {
        let ekCards = cards.compactMap { $0 as? ExplodingKittensCard }

        guard !ekCards.isEmpty else {
            return false
        }

        if ekCards.count == 1 {
            let card = ekCards[0]
            return ExplodingKittensConstants.actionCards.contains(card.type)
        }

        if ekCards.count == 2 || ekCards.count == 3 {
            return checkSameCards(cards: ekCards)
        }

        if ekCards.count == 5 {
            return checkDifferentCards(cards: ekCards)
        }

        return false
    }

    private func checkSameCards(cards: [ExplodingKittensCard]) -> Bool {
        let cardTypes = cards.compactMap { card in
            card.type
        }

        return cardTypes.allSatisfy({ cardType in
            cardType == cardTypes[0]
        })
    }

    private func checkDifferentCards(cards: [ExplodingKittensCard]) -> Bool {
        let cardTypes = cards.compactMap { card in
            card.type
        }

        var cardTypeSet: Set<ExplodingKittensCardType> = Set()
        cardTypes.forEach { cardType in
            cardTypeSet.insert(cardType)
        }

        return cardTypeSet.count == cards.count
    }

    override func playCards(_ cards: [Card], gameRunner: GameRunnerProtocol, on target: GameplayTarget) {
        let ekCards = cards.compactMap { $0 as? ExplodingKittensCard }

        guard !ekCards.isEmpty else {
            return
        }

        if ekCards.count == 1 {
            let card = ekCards[0]
            card.onPlay(gameRunner: gameRunner, player: self, on: target)
        }

        guard let ekGameRunner = gameRunner as? ExplodingKittensGameRunnerProtocol else {
            return
        }

        guard let playerHand = ekGameRunner.getHandByPlayer(self) else {
            return
        }

        let moveCardsEvent = ekCards.map { card in
            MoveCardDeckToDeckEvent(card: card, fromDeck: playerHand, toDeck: ekGameRunner.gameplayArea)
        }

        gameRunner.executeGameEvents(moveCardsEvent)
    }

    private static func playPairCombo() {

    }
}
