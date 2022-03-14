//
//  IncrementPlayerCardsPlayedEvent.swift
//  CardBox
//
//  Created by mactest on 13/03/2022.
//

struct IncrementPlayerCardsPlayedEvent: GameEvent {
    let player: Player

    func updateRunner(gameRunner: GameRunnerUpdateOnly) {
        player.incrementCardsPlayed()
    }
}
