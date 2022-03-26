//
//  CardTypeRequestEvent.swift
//  CardBox
//
//  Created by Stuart Long on 19/3/22.
//

struct CardTypeRequestArgs {
    let target: Player
    // Currently included player because current player would change when end turn is called
    // The response event happens only after the player's turn end
    let player: Player
}

struct CardTypeRequestEvent: GameEvent {
    let target: Player
    let player: Player

    func updateRunner(gameRunner: GameRunnerProtocol) {
        let args = CardTypeRequestArgs(target: target, player: player)
//        gameRunner.setCardTypeRequestArgs(args)
//        gameRunner.toggleCardTypeRequest(to: true)
    }
}
