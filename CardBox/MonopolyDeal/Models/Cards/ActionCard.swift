//
//  ActionCard.swift
//  CardBox
//
//  Created by Bernard Wan on 17/4/22.
//

import Foundation

class ActionCard: MonopolyDealCard {

    init(name: String, typeOfTargettedCard: TypeOfTargettedCard) {
        super.init(
            name: name,
            typeOfTargettedCard: typeOfTargettedCard
        )
    }

    override func onPlay(gameRunner: MDGameRunnerProtocol, player: MDPlayer, on target: GameplayTarget) {
        guard let gameState = gameRunner.gameState as? MonopolyDealGameState else {
            return
        }

        guard let hand = gameState.playerHands[player.id] else {
            return
        }

        guard let moneyArea = gameState.playerMoneyArea[player.id] else {
            return
        }

        gameRunner.executeGameEvents([
            MoveCardsDeckToDeckEvent(cards: [self], fromDeck: hand, toDeck: moneyArea)
        ])
    }

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
    }
}
