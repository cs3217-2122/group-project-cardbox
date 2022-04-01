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
        let displayedCards = gameRunner.deck.getTopNCards(n: 3)
        gameRunner.setCardsPeeking(cards: displayedCards)

        super.onPlay(gameRunner: gameRunner, player: player, on: target)
    }
}
