//
//  MoveCardGameplayToPlayerEvent.swift
//  CardBox
//
//  Created by Bryann Yeap Kok Keong on 19/3/22.
//

struct MoveCardGameplayToPlayerEvent: GameEvent {
    let card: Card
    let player: Player

    func updateRunner(gameRunner: GameRunnerUpdateOnly) {
        player.addCard(card)
        gameRunner.gameplayArea.removeCard(card)
    }
}
