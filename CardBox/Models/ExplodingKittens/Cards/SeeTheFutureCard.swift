//
//  SeeTheFutureCard.swift
//  CardBox
//
//  Created by mactest on 25/03/2022.
//

class SeeTheFutureCard: ExplodingKittensCard {
    init() {
        super.init(
            name: "See The Future",
            typeOfTargettedCard: .noTargetCard,
            type: .seeTheFuture
        )
    }

    override func onPlay(gameRunner: EKGameRunnerProtocol, player: EKPlayer, on target: GameplayTarget) {
        guard let playerHand = gameRunner.getHandByPlayer(player) else {
            return
        }

        gameRunner.executeGameEvents([
            CustomizedGameEvent(customizedGameEvent: DisplayTopNCardsEvent(n: 3, deck: gameRunner.deck))
         ])
    }
}
