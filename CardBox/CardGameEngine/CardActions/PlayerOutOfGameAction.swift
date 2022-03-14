//
//  PlayerOutOfGameAction.swift
//  CardBox
//
//  Created by mactest on 11/03/2022.
//

struct PlayerOutOfGameAction: CardAction {
    func executeGameEvents(gameRunner: GameRunnerReadOnly, player: Player, target: GameplayTarget) {
        gameRunner.executeGameEvents([
            SetPlayerOutOfGameEvent(player: player)
        ])
    }
}
