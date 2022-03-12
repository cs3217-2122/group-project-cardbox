//
//  PlayCardAction.swift
//  CardBox
//
//  Created by mactest on 12/03/2022.
//

struct PlayCardAction: Action {
    let player: Player
    let card: Card
    let target: GameplayTarget

    func executeGameEvents(gameRunner: GameRunnerReadOnly) {
        guard card.canPlay(by: player, gameRunner: gameRunner, on: target) else {
            return
        }

        let action = PlayCardAction(player: player, card: card, target: target)

        action.executeGameEvents(gameRunner: gameRunner)

        card.onPlay(gameRunner: gameRunner, player: player, on: target)
    }
}
