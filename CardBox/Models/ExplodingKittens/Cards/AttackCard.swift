//
//  AttackCard.swift
//  CardBox
//
//  Created by mactest on 25/03/2022.
//

class AttackCard: ExplodingKittensCard {
    init() {
        super.init(
            name: "Attack",
            typeOfTargettedCard: .noTargetCard,
            type: .attack
        )
    }

    override func onPlay(gameRunner: EKGameRunnerProtocol, player: ExplodingKittensPlayer, on target: GameplayTarget) {
        guard let nextPlayer = gameRunner.getNextPlayer() as? ExplodingKittensPlayer else {
            return
        }

        guard let playerHand = gameRunner.getHandByPlayer(player) else {
            return
        }

        nextPlayer.incrementAttackCount()

        gameRunner.executeGameEvents([
            AdvanceNextPlayerEvent(),
            MoveCardsDeckToDeckEvent(cards: [self], fromDeck: playerHand, toDeck: gameRunner.gameplayArea)
        ])
    }
}
