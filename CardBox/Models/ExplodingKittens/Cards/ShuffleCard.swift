//
//  ShuffleCard.swift
//  CardBox
//
//  Created by mactest on 25/03/2022.
//

class ShuffleCard: ExplodingKittensCard {
    init() {
        super.init(
            name: "Shuffle",
            typeOfTargettedCard: .noTargetCard,
            type: .shuffle
        )
    }

    override func onPlay(gameRunner: EKGameRunnerProtocol, player: EKPlayer, on target: GameplayTarget) {
        guard let playerHand = gameRunner.getHandByPlayer(player) else {
            return
        }

        gameRunner.executeGameEvents([
            ShuffleDeckEvent(deck: gameRunner.deck)
        ])
    }
}
