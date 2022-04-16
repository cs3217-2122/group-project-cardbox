//
//  SeeTheFutureCard.swift
//  CardBox
//
//  Created by mactest on 25/03/2022.
//
import Foundation

class SeeTheFutureCard: ExplodingKittensCard {
    init() {
        super.init(
            name: "See The Future",
            typeOfTargettedCard: .noTargetCard,
            type: .seeTheFuture
        )
    }

    init(id: UUID) {
        super.init(
            id: id,
            name: "See The Future",
            typeOfTargettedCard: .noTargetCard,
            type: .seeTheFuture
        )
    }

    override func onPlay(gameRunner: EKGameRunnerProtocol, player: EKPlayer, on target: GameplayTarget) {

        guard let gameState = gameRunner.gameState as? ExplodingKittensGameState else {
            return
        }

        gameRunner.executeGameEvents([
            CustomizedGameEvent(customizedGameEvent: DisplayTopNCardsEvent(n: 3, deck: gameState.deck))
         ])
    }

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
    }
}
