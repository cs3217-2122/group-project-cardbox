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

        guard let ekGameRunner = gameRunner as? ExplodingKittensGameRunnerProtocol else {
            return
        }

        guard let playerHand = ekGameRunner.getHandByPlayer(self) else {
            return
        }

        if ekCards.count == 1 {
            let card = ekCards[0]
            card.onPlay(gameRunner: gameRunner, player: self, on: target)
        } else if ekCards.count == 2 {
            playPairCombo(cards, ekGameRunner: ekGameRunner, player: self, on: target)
        } else if ekCards.count == 3 {
            playThreeOfAKindCombo(cards, ekGameRunner: ekGameRunner, player: self, on: target)
        } else if ekCards.count == 5 {
            playFiveDifferentCardsCombo(cards, ekGameRunner: ekGameRunner, player: self, on: target)
        } else {
            return
        }

        gameRunner.executeGameEvents([
            MoveCardsDeckToDeckEvent(cards: cards, fromDeck: playerHand, toDeck: ekGameRunner.gameplayArea)
        ])
    }

    private func playPairCombo(_ cards: [Card],
                               ekGameRunner: ExplodingKittensGameRunnerProtocol,
                               player: Player,
                               on target: GameplayTarget) {
         guard let cards = cards as? [ExplodingKittensCard],
               checkSameCards(cards: cards) else {
             return
         }

        // Temporary hack, will change to update with events
        guard let ekGameRunner = ekGameRunner as? ExplodingKittensGameRunner else {
            return
        }

        guard let playerHand = ekGameRunner.getHandByPlayer(player) else {
            return
        }

        guard let targetPlayer = target.getPlayerIfTargetSingle() else {
            return
        }

        guard let targetHand = ekGameRunner.getHandByPlayer(targetPlayer) else {
            return
        }

        ekGameRunner.deckPositionRequest.showRequest(
            callback: { position in
                guard let targetCard = targetHand.getCardByIndex(position - 1) else {
                    return
                }

                ekGameRunner.executeGameEvents([
                    MoveCardsDeckToDeckEvent(cards: [targetCard], fromDeck: targetHand, toDeck: playerHand)
                 ])
            },
            maxValue: targetHand.count
        )
     }

    private func playThreeOfAKindCombo(_ cards: [Card],
                                       ekGameRunner: ExplodingKittensGameRunnerProtocol,
                                       player: Player,
                                       on target: GameplayTarget) {
         guard let cards = cards as? [ExplodingKittensCard],
               checkSameCards(cards: cards) else {
             return
         }

        // Temporary hack, will change to update with events
        guard let ekGameRunner = ekGameRunner as? ExplodingKittensGameRunner else {
            return
        }

        guard let playerHand = ekGameRunner.getHandByPlayer(player) else {
            return
        }

        guard let targetPlayer = target.getPlayerIfTargetSingle() else {
            return
        }

        guard let targetHand = ekGameRunner.getHandByPlayer(targetPlayer) else {
            return
        }

        ekGameRunner.cardTypeRequest.showRequest(callback: { card in
            guard let chosenCard = targetHand.getCard(where: {
                guard let ekCard = $0 as? ExplodingKittensCard else {
                    return false
                }

                return ekCard.type.rawValue == card
            }) else {
                return
            }

            ekGameRunner.executeGameEvents([
                MoveCardsDeckToDeckEvent(cards: [chosenCard], fromDeck: targetHand, toDeck: playerHand)
            ])
        })
     }

    private func playFiveDifferentCardsCombo(_ cards: [Card],
                                             ekGameRunner: ExplodingKittensGameRunnerProtocol,
                                             player: Player,
                                             on target: GameplayTarget) {
         guard let cards = cards as? [ExplodingKittensCard],
               checkDifferentCards(cards: cards) else {
             return
         }

        guard let playerHand = ekGameRunner.getHandByPlayer(player) else {
            return
        }

        guard let defuseCard = ekGameRunner.gameplayArea.getCard(where: { type(of: $0) == DefuseCard.self }) else {
            return
        }

        // TODO: Allow player to choose card, for now default DEFUSE
        ekGameRunner.executeGameEvents([
            MoveCardsDeckToDeckEvent(cards: [defuseCard], fromDeck: ekGameRunner.gameplayArea, toDeck: playerHand)
        ])
     }
}
