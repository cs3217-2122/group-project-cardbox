//
//  PlayerHandPositionRequestEvent.swift
//  CardBox
//
//  Created by Bryann Yeap Kok Keong on 19/3/22.
//

struct PlayerHandPositionRequestArgs {
    let target: Player
    // Currently included player because current player would change when end turn is called
    // The response event happens only after the player's turn end
    let player: Player
}

struct PlayerHandPositionRequestEvent: GameEvent {
    let target: Player
    let player: Player

    func updateRunner(gameRunner: GameRunnerUpdateOnly) {
        let args = PlayerHandPositionRequestArgs(target: target, player: player)
        gameRunner.setPlayerHandPositionRequestArgs(args)
        gameRunner.togglePlayerHandPositionRequest(to: true)
    }
}
