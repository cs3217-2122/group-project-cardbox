//
//  MoveCard.swift
//  CardBox
//
//  Created by mactest on 11/03/2022.
//

struct MoveCardPlayerToGameplayEvent: GameEvent {
    let card: Card
    let player: Player

    func updateRunner(gameRunner: GameRunnerUpdateOnly) {
        player.removeCard(card)
        gameRunner.gameplayArea.addCard(card)
    }
}
