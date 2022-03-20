//
//  ExplodingKittensPlayerPlayCondition.swift
//  CardBox
//
//  Created by mactest on 17/03/2022.
//

struct ExplodingKittensPlayerPlayCondition: PlayerPlayCondition {
    let nonActionCards: Set<ExplodingKittensCardType> = [
        .random1,
        .random2,
        .random3
    ]
    let actionCards: Set<ExplodingKittensCardType> = [
        .attack,
        .favor,
        .nope,
        .seeTheFuture,
        .shuffle,
        .skip,
        .favor
    ]
    var playableCards: Set<ExplodingKittensCardType> {
        nonActionCards.union(actionCards)
    }

    func evaluate(gameRunner: GameRunnerReadOnly, args: PlayerPlayConditionArgs) -> Bool {
        let cards = args.cards

        guard !cards.isEmpty else {
            return false
        }

        if cards.count == 1 {
            let card = cards[0]

            guard let cardType = ExplodingKittensUtils.getCardType(card: card) else {
                return false
            }
            return actionCards.contains(cardType)
        }

        if cards.count == 2 || cards.count == 3 {
            return checkSameCards(cards: cards)
        }

        if cards.count == 5 {
            return checkDifferentCards(cards: cards)
        }

        return false
    }

    private func checkSameCards(cards: [Card]) -> Bool {
        let cardTypes = cards.compactMap { card in
            ExplodingKittensUtils.getCardType(card: card)
        }

        return cardTypes.allSatisfy({ cardType in
            cardType == cardTypes[0]
        })
    }

    private func checkDifferentCards(cards: [Card]) -> Bool {
        let cardTypes = cards.compactMap { card in
            ExplodingKittensUtils.getCardType(card: card)
        }

        var cardTypeSet: Set<ExplodingKittensCardType> = Set()
        cardTypes.forEach { cardType in
            cardTypeSet.insert(cardType)
        }

        return cardTypeSet.count == cards.count
    }
}
