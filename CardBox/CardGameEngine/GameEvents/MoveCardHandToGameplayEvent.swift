//
//  MoveCardHandToGameplayEvent.swift
//  CardBox
//
//  Created by Bryann Yeap Kok Keong on 31/3/22.
//

struct MoveCardHandToGameplayEvent: GameEvent {
    let player: Player
    let card: Card

    func updateRunner(gameRunner: GameRunnerProtocol) {
        guard let ekGameRunner = gameRunner as? ExplodingKittensGameRunner else {
            return
        }

        guard let hand = ekGameRunner.getHandByPlayer(player) else {
            return
        }

        hand.removeCard(card)
        ekGameRunner.gameplayArea.addCard(card, offsetFromTop: 0)
    }
}
