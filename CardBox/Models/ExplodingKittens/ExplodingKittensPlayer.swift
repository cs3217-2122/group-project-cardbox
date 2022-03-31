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
        } else if ekCards.count == 2 {
            playPairCombo(cards, gameRunner: gameRunner)
        } else if ekCards.count == 3 {
            playThreeOfAKindCombo(cards, gameRunner: gameRunner)
        } else if ekCards.count == 5 {
            playFiveDifferentCardsCombo(cards, gameRunner: gameRunner)
        } else {
            return
        }
    }

    private func playPairCombo(_ cards: [Card], gameRunner: GameRunnerProtocol) {
        guard let cards = cards as? [ExplodingKittensCard],
              checkSameCards(cards: cards) else {
            return
        }

        gameRunner.executeGameEvents([
        
        ])
    }

    private func playThreeOfAKindCombo(_ cards: [Card], gameRunner: GameRunnerProtocol) {
        guard let cards = cards as? [ExplodingKittensCard],
              checkSameCards(cards: cards) else {
            return
        }

        gameRunner.executeGameEvents([
        
        ])
    }

    private func playFiveDifferentCardsCombo(_ cards: [Card], gameRunner: GameRunnerProtocol) {
        guard let cards = cards as? [ExplodingKittensCard],
              checkDifferentCards(cards: cards) else {
            return
        }

        gameRunner.executeGameEvents([
        
        ])
    }
}
