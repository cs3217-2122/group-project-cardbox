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
            typeOfTargettedCard: .targetAllPlayersCard,
            type: .birthday
        )
    }

    override func onPlay(gameRunner: MDGameRunnerProtocol, player: MDPlayer, on target: GameplayTarget) {
        if case .all = target {
            // Request 2 million from all players
        }
    }
}
