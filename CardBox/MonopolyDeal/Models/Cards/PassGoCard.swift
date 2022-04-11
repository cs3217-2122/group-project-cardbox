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
            typeOfTargettedCard: .noTargetCard,
            type: .passGo
        )
    }

    override func onPlay(gameRunner: MDGameRunnerProtocol, player: MDPlayer, on target: GameplayTarget) {
        let deck = gameRunner.deck

        guard let hand = gameRunner.playerHands[player.id] else {
            return
        }

        let cards = deck.getTopNCards(n: 2)

        gameRunner.executeGameEvents([
            MoveCardsDeckToDeckEvent(cards: cards, fromDeck: deck, toDeck: hand)
        ])
    }

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
    }
}
