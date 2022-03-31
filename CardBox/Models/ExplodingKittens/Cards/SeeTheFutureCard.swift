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

    // To be overwritten
    override func onPlay(gameRunner: GameRunnerProtocol, player: Player, on target: GameplayTarget) {
        guard let ekGameRunner = gameRunner as? ExplodingKittensGameRunner else {
            return
        }

        let displayedCards = ekGameRunner.deck.getTopNCards(n: 3)
        ekGameRunner.setCardsPeeking(cards: displayedCards)

        gameRunner.executeGameEvents([
            MoveCardHandToGameplayEvent(player: player, card: self)
        ])
    }
}
