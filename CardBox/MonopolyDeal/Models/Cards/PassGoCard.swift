//
//  PassGoCard.swift
//  CardBox
//
//  Created by user213938 on 4/3/22.
//

class PassGoCard: MonopolyDealCard {
    init() {
        super.init(
            name: "Go",
            typeOfTargettedCard: .noTargetCard
        )
    }

    override func onPlay(gameRunner: MDGameRunnerProtocol, player: MDPlayer, on target: GameplayTarget) {
        guard let gameState = gameRunner.gameState as? MonopolyDealGameState else {
            return
        }

        let deck = gameState.deck

        guard let hand = gameState.playerHands[player.id] else {
            return
        }

        let cards = deck.getTopNCards(n: 2)

        gameRunner.executeGameEvents([
            MoveCardsDeckToDeckEvent(cards: cards, fromDeck: deck, toDeck: hand),
            MoveCardsDeckToDeckEvent(cards: [self], fromDeck: hand, toDeck: gameRunner.gameplayArea)
        ])
    }

    override func getBankValue() -> Int {
        guard let bankValue = MonopolyDealCardType.passGo.bankValue else {
            assert(false, "Unable to obtain bank value of pass go card")
        }
        return bankValue
    }

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
    }
}
