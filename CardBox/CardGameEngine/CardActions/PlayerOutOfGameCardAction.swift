//
//  PlayerOutOfGameCardAction.swift
//  CardBox
//
//  Created by mactest on 11/03/2022.
//

struct PlayerOutOfGameCardAction: CardAction {
    func executeGameEvents(gameRunner: GameRunnerReadOnly, args: CardActionArgs) {
        gameRunner.executeGameEvents([
            SetPlayerOutOfGameEvent(player: args.player)
        ])
    }
}
