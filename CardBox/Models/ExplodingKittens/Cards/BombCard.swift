//
//  BombCard.swift
//  CardBox
//
//  Created by mactest on 26/03/2022.
//
import Foundation

class BombCard: ExplodingKittensCard {
    init() {
        super.init(
            name: "Bomb",
            typeOfTargettedCard: .targetSinglePlayerCard,
            type: .bomb
        )
    }

    init(id: UUID) {
        super.init(
            id: id,
            name: "Bomb",
            typeOfTargettedCard: .targetSinglePlayerCard,
            type: .bomb
        )
    }

    override func onDraw(gameRunner: EKGameRunnerProtocol, player: EKPlayer) {
        guard let playerHand = gameRunner.getHandByPlayer(player) else {
            return
        }

        guard let defuseCard = playerHand.getCard(where: { isDefuseCard($0) }) else {
            gameRunner.executeGameEvents([SetPlayerOutOfGameEvent(player: player)])
            return
        }

        let callback: (Int) -> Void = { position in
            gameRunner.executeGameEvents([
                MoveCardsDeckToDeckEvent(cards: [defuseCard],
                                         fromDeck: playerHand,
                                         toDeck: gameRunner.gameplayArea),
                MoveCardsDeckToDeckEvent(cards: [self],
                                         fromDeck: playerHand,
                                         toDeck: gameRunner.deck,
                                         offsetFromTop: position - 1)
            ])
        }

        gameRunner.executeGameEvents([
            ShowCardPositionRequestEvent(callback: callback,
                                         minValue: 1,
                                         maxValue: gameRunner.deck.count)
        ])
    }

    private func isDefuseCard(_ card: Card) -> Bool {
        guard let ekCard = card as? ExplodingKittensCard else {
            return false
        }

        return ekCard.type == .defuse
    }
}
