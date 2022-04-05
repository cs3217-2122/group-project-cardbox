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

        let callback: (Int) -> Void = { position in
            guard let targetCard = targetHand.getCardByIndex(position - 1) else {
                return
            }

            gameRunner.executeGameEvents([
                MoveCardsDeckToDeckEvent(cards: [targetCard], fromDeck: targetHand, toDeck: playerHand)
            ])
        }

        gameRunner.executeGameEvents([
            ShowCardPositionRequestEvent(callback: callback,
                                         minValue: 1,
                                         maxValue: targetHand.count)
        ])
    }
}
