//
//  BirthdayCard.swift
//  CardBox
//
//  Created by user213938 on 4/3/22.
//

class BirthdayCard: MonopolyDealCard {
    init() {
        super.init(
            name: "Birthday",
            typeOfTargettedCard: .targetAllPlayersCard
        )
    }

    override func onPlay(gameRunner: MDGameRunnerProtocol, player: MDPlayer, on target: GameplayTarget) {
        if case .all = target {
            // Request 2 million from all players
        }
    }

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
    }
}
