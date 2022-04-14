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
        gameRunner.executeGameEvents([
            CustomizedGameEvent(customizedGameEvent: DisplayTopNCardsEvent(n: 3, deck: gameRunner.deck))
         ])
    }
}
