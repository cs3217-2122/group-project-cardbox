//
//  CardRequestEvent.swift
//  CardBox
//
//  Created by Stuart Long on 19/3/22.
//

struct CardRequestArgs {
    let target: Player
    // Currently included player because current player would change when end turn is called
    // The response event happens only after the player's turn end
    let player: Player
}

struct CardRequestEvent: GameEvent {
    let target: Player
    let player: Player

    func updateRunner(gameRunner: GameRunnerUpdateOnly) {
        let args = CardRequestArgs(target: target, player: player)
        gameRunner.setCardRequestArgs(args)
        gameRunner.toggleCardRequest(to: true)
    }
}
