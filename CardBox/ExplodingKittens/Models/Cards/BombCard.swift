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

        let callback: (Response) -> Void = { response in
            guard let intResponse = response as? IntResponse else {
                return
            }

            gameRunner.executeGameEvents([
                MoveCardsDeckToDeckEvent(cards: [defuseCard],
                                         fromDeck: playerHand,
                                         toDeck: gameRunner.gameplayArea),
                MoveCardsDeckToDeckEvent(cards: [self],
                                         fromDeck: playerHand,
                                         toDeck: gameRunner.deck,
                                         offsetFromTop: intResponse.value - 1)
            ])
        }

        gameRunner.executeGameEvents([
            SendRequestEvent(request: IntRequest(
                description: "You drew the bomb :( Please choose a position of the draw deck to insert the bomb in",
                fromPlayer: player,
                toPlayer: player,
                callback: callback,
                minValue: 1,
                maxValue: gameRunner.deck.count
            ))
        ])
    }

    private func isDefuseCard(_ card: Card) -> Bool {
        guard let ekCard = card as? ExplodingKittensCard else {
            return false
        }

        return ekCard.type == .defuse
    }
}
