//
//  FavorCard.swift
//  CardBox
//
//  Created by mactest on 26/03/2022.
//
import Foundation

class FavorCard: ExplodingKittensCard {
    init() {
        super.init(
            name: "Favor",
            typeOfTargettedCard: .targetSinglePlayerCard,
            type: .favor
        )
    }

    init(id: UUID) {
        super.init(
            id: id,
            name: "Favor",
            typeOfTargettedCard: .targetSinglePlayerCard,
            type: .favor
        )
    }

    override func onPlay(gameRunner: EKGameRunnerProtocol, player: EKPlayer, on target: GameplayTarget) {
        guard let targetPlayer = target.getPlayerIfTargetSingle() else {
            return
        }

        guard let playerHand = gameRunner.getHandByPlayer(player) else {
            return
        }

        guard let targetHand = gameRunner.getHandByPlayer(targetPlayer) else {
            return
        }

        let callback: (Response) -> Void = { response in
            guard let intResponse = response as? IntResponse else {
                return
            }

            guard let targetCard = targetHand.getCardByIndex(intResponse.value - 1) else {
                return
            }

            gameRunner.executeGameEvents([
                MoveCardsDeckToDeckEvent(cards: [targetCard], fromDeck: targetHand, toDeck: playerHand)
            ])
        }

        gameRunner.executeGameEvents([
            SendRequestEvent(
                request: IntRequest(description: "Please choose the position of the card you want to give away",
                                    fromPlayer: player,
                                    toPlayer: targetPlayer,
                                    callback: Callback(callback),
                                    minValue: 1,
                                    maxValue: targetHand.count
                                   )
            )
        ])
    }

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
    }
}
