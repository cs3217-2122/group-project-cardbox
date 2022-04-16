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
            type(of: card)
        }

        return cardTypes.allSatisfy({ cardType in
            cardType == cardTypes[0]
        })
    }

    private func checkDifferentCards(cards: [ExplodingKittensCard]) -> Bool {
        let cardTypes = cards.compactMap { card in
            type(of: card)
        }

        var cardTypeSet: [ExplodingKittensCard.Type] = []
        cardTypes.forEach { cardType in
            if !cardTypeSet.contains(where: { $0 == cardType }) {
                cardTypeSet.append(cardType)
            }
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

        let playerHand = ekGameRunner.getHandByPlayer(self)

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

        let playerHand = ekGameRunner.getHandByPlayer(player)

        guard let targetPlayer = target.getPlayerIfTargetSingle() else {
            return
        }

        let targetHand = ekGameRunner.getHandByPlayer(targetPlayer)

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
                                                 callback: Callback(callback),
                                                 minValue: 1,
                                                 maxValue: targetHand.count
                                                )
                            )
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

        let playerHand = ekGameRunner.getHandByPlayer(player)

        guard let targetPlayer = target.getPlayerIfTargetSingle() else {
            return
        }

        let targetHand = ekGameRunner.getHandByPlayer(targetPlayer)

        let callback: (Response) -> Void = { response in
            guard let optionsResponse = response as? OptionsResponse else {
                return
            }

            guard let chosenCard = targetHand.getCard(where: {
                guard let ekCard = $0 as? ExplodingKittensCard else {
                    return false
                }

                return ekCard.type.rawValue == optionsResponse.value
            }) else {
                return
            }

            ekGameRunner.executeGameEvents([
                MoveCardsDeckToDeckEvent(cards: [chosenCard], fromDeck: targetHand, toDeck: playerHand)
            ])
        }

        ekGameRunner.executeGameEvents([
            SendRequestEvent(
                request: OptionsRequest(description: "Please choose the type of card that you want to take",
                                        fromPlayer: player,
                                        toPlayer: targetPlayer,
                                        callback: Callback(callback),
                                        stringRepresentationOfOptions: ExplodingKittensConstants.allCardTypes.map({
                                            $0.rawValue
                                        }))
            )
        ])
     }

    private func playFiveDifferentCardsCombo(_ cards: [Card],
                                             ekGameRunner: ExplodingKittensGameRunnerProtocol,
                                             player: Player) {
        guard let cards = cards as? [ExplodingKittensCard],
              checkDifferentCards(cards: cards) else {
            return
        }

        let playerHand = ekGameRunner.getHandByPlayer(player)

        let callback: (Response) -> Void = { response in
            guard let optionsResponse = response as? OptionsResponse else {
                return
            }

            guard let chosenCard = ekGameRunner.gameplayArea.getCard(where: {
                guard let ekCard = $0 as? ExplodingKittensCard else {
                    return false
                }

                return ekCard.type.rawValue == optionsResponse.value
            }) else {
                return
            }

            ekGameRunner.executeGameEvents([
                MoveCardsDeckToDeckEvent(cards: [chosenCard], fromDeck: ekGameRunner.gameplayArea, toDeck: playerHand)
            ])
        }

        ekGameRunner.executeGameEvents([
            SendRequestEvent(
                request: OptionsRequest(description: "Please choose a card that you want to take from the play area",
                                        fromPlayer: player,
                                        toPlayer: player,
                                        callback: Callback(callback),
                                        stringRepresentationOfOptions:
                                            getCardTypesCurrentlyInGameplay(gameRunner: ekGameRunner))
            )
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

    private enum CodingKeys: String, CodingKey {
        case attackCount
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.attackCount = try container.decode(Int.self, forKey: .attackCount)
        try super.init(from: decoder)
    }

    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(attackCount, forKey: .attackCount)
        try super.encode(to: encoder)
    }
}
