//
//  ResetPlayerCardsPlayed.swift
//  CardBox
//
//  Created by mactest on 13/03/2022.
//

struct ResetPlayerCardsPlayedEvent: GameEvent {
    let player: Player

    func updateRunner(gameRunner: GameRunnerUpdateOnly) {
        player.resetCardsPlayed()
    }
}
