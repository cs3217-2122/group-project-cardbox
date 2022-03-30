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

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    // To be overwritten
    override func onPlay(gameRunner: GameRunnerProtocol, player: Player, on target: GameplayTarget) {
        guard let ekGameRunner = gameRunner as? ExplodingKittensGameRunner else {
            return
        }

        ekGameRunner.deck.shuffle()
    }
}
