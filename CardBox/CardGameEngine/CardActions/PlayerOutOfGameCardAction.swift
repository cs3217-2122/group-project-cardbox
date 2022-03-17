//
//  PlayerOutOfGameCardAction.swift
//  CardBox
//
//  Created by mactest on 11/03/2022.
//

struct PlayerOutOfGameCardAction: CardAction {
    func executeGameEvents(gameRunner: GameRunnerReadOnly, card: Card, player: Player, target: GameplayTarget) {
        gameRunner.executeGameEvents([
            SetPlayerOutOfGameEvent(player: player)
        ])
    }
}
