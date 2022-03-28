//
//  DeckPositionRequestEvent.swift
//  CardBox
//
//  Created by mactest on 16/03/2022.
//

struct DeckPositionRequestArgs {
    let card: Card
    // Currently included player because current player would change when end turn is called
    // The response event happens only after the player's turn end
    let player: Player
}

struct DeckPositionRequestEvent: GameEvent {
    let card: Card
    let player: Player

    func updateRunner(gameRunner: GameRunnerProtocol) {
//        let args = DeckPositionRequestArgs(card: card, player: player)
//        gameRunner.setDeckPositionRequestArgs(args)
//        gameRunner.toggleDeckPositionRequest(to: true)
    }
}
