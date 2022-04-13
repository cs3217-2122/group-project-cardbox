//
//  ExplodingKittensPlayer.swift
//  CardBox
//
//  Created by mactest on 25/03/2022.
//

import Foundation

class ExplodingKittensPlayer: Player {
    private(set) var attackCount = 0

    init(name: String,
         id: UUID = UUID(),
         isOutOfGame: Bool = false,
         cardsPlayed: Int = 0,
         attackCount: Int = 0) {
        self.attackCount = attackCount
        super.init(id: id, name: name, isOutOfGame: isOutOfGame, cardsPlayed: cardsPlayed)
    }

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

    override func determineTargetOfCards(_ cards: [Card], gameRunner: GameRunnerProtocol) -> TypeOfTargettedCard? {
        guard canPlay(cards: cards, gameRunner: gameRunner) else {
            return nil
        }

        switch cards.count {
        case 1:
            return cards[0].typeOfTargettedCard
        case 2, 3:
            return .targetSinglePlayerCard
        case 5:
            return .noTargetCard
        default:
            return nil
        }
    }

    override func playCards(_ cards: [Card], gameRunner: GameRunnerProtocol, on target: GameplayTarget) {
        let ekCards = cards.compactMap { $0 as? ExplodingKittensCard }

        guard canPlay(cards: cards, gameRunner: gameRunner) else {
            return
        }

        guard !ekCards.isEmpty else {
            return
        }

        guard let ekGameRunner = gameRunner as? ExplodingKittensGameRunnerProtocol else {
            return
        }

        guard let playerHand = ekGameRunner.getHandByPlayer(self) else {
            return
        }

        switch ekCards.count {
        case 1:
            let card = ekCards[0]
            card.onPlay(gameRunner: gameRunner, player: self, on: target)
        case 2:
            playPairCombo(cards, ekGameRunner: ekGameRunner, player: self, on: target)
        case 3:
            playThreeOfAKindCombo(cards, ekGameRunner: ekGameRunner, player: self, on: target)
        case 5:
            playFiveDifferentCardsCombo(cards, ekGameRunner: ekGameRunner, player: self)
        default:
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

        guard let playerHand = ekGameRunner.getHandByPlayer(player) else {
            return
        }

        guard let targetPlayer = target.getPlayerIfTargetSingle() else {
            return
        }

        guard let targetHand = ekGameRunner.getHandByPlayer(targetPlayer) else {
            return
        }

        let callback: (Response) -> Void = { response in
            guard let intResponse = response as? IntResponse else {
                return
            }

            guard let targetCard = targetHand.getCardByIndex(intResponse.value - 1) else {
                return
            }

            ekGameRunner.executeGameEvents([
                MoveCardsDeckToDeckEvent(cards: [targetCard], fromDeck: targetHand, toDeck: playerHand)
             ])
        }

        ekGameRunner.executeGameEvents([
            SendRequestEvent(request: IntRequest(description: "Please choose the position of the card you want to take",
                                                 fromPlayer: player,
                                                 toPlayer: player,
                                                 minValue: 1,
                                                 maxValue: targetHand.count,
                                                 callback: callback))
        ])
     }

    private func playThreeOfAKindCombo(_ cards: [Card],
                                       ekGameRunner: ExplodingKittensGameRunnerProtocol,
                                       player: Player,
                                       on target: GameplayTarget) {
         guard let cards = cards as? [ExplodingKittensCard],
               checkSameCards(cards: cards) else {
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

        let callback: (String) -> Void = { cardType in
            guard let chosenCard = targetHand.getCard(where: {
                guard let ekCard = $0 as? ExplodingKittensCard else {
                    return false
                }

                return ekCard.type.rawValue == cardType
            }) else {
                return
            }

            ekGameRunner.executeGameEvents([
                MoveCardsDeckToDeckEvent(cards: [chosenCard], fromDeck: targetHand, toDeck: playerHand)
            ])
        }

        ekGameRunner.executeGameEvents([
            ShowCardTypeRequestEvent(callback: callback,
                                     cardTypes: ExplodingKittensConstants.allCardTypes.map({ $0.rawValue }))
        ])
     }

    private func playFiveDifferentCardsCombo(_ cards: [Card],
                                             ekGameRunner: ExplodingKittensGameRunnerProtocol,
                                             player: Player) {
         guard let cards = cards as? [ExplodingKittensCard],
               checkDifferentCards(cards: cards) else {
             return
         }

        guard let playerHand = ekGameRunner.getHandByPlayer(player) else {
            return
        }

        let callback: (String) -> Void = { cardType in
            guard let chosenCard = ekGameRunner.gameplayArea.getCard(where: {
                guard let ekCard = $0 as? ExplodingKittensCard else {
                    return false
                }

                return ekCard.type.rawValue == cardType
            }) else {
                return
            }

            ekGameRunner.executeGameEvents([
                MoveCardsDeckToDeckEvent(cards: [chosenCard], fromDeck: ekGameRunner.gameplayArea, toDeck: playerHand)
            ])
        }

        ekGameRunner.executeGameEvents([
            ShowCardTypeRequestEvent(callback: callback,
                                     cardTypes: getCardTypesCurrentlyInGameplay(gameRunner: ekGameRunner))
        ])

     }

    private func getCardTypesCurrentlyInGameplay(gameRunner: ExplodingKittensGameRunnerProtocol) -> [String] {
        let nonDistinctCardTypes: [String] = gameRunner.gameplayArea.getCards().map({
            guard let ekCard = $0 as? ExplodingKittensCard else {
                return ""
            }
            return ekCard.type.rawValue
        })

        var distinctCardTypes: Set<String> = Set()
        nonDistinctCardTypes.forEach { cardType in
            distinctCardTypes.insert(cardType)
        }

        return Array(distinctCardTypes)
    }
}
