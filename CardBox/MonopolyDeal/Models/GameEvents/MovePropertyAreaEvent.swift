//
//  MovePropertyAreaEvent.swift
//  CardBox
//
//  Created by user213938 on 4/6/22.
//

struct MovePropertyAreaEvent: GameEvent {
    let cardSet: MonopolyDealPropertySet
    let fromPlayer: MonopolyDealPlayer
    let toPlayer: MonopolyDealPlayer

    func updateRunner(gameRunner: GameRunnerProtocol) {
        guard let gameRunner = gameRunner as? MonopolyDealGameRunnerProtocol else {
            return
        }

        let fromArea = gameRunner.getPropertyAreaByPlayer(fromPlayer)
        let toArea = gameRunner.getPropertyAreaByPlayer(toPlayer)
        fromArea.removeCardCollection(cardSet)
        toArea.addCardCollection(cardSet)
    }
}
