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
    override func onPlay(gameRunner: GameRunnerReadOnly, player: Player, on target: GameplayTarget) {

    }
}
