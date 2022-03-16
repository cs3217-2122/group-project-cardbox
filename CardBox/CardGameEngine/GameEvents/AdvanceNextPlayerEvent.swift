//
//  AdvanceNextPlayerEvent.swift
//  CardBox
//
//  Created by Bryann Yeap Kok Keong on 16/3/22.
//

struct AdvanceNextPlayerEvent: GameEvent {

    func updateRunner(gameRunner: GameRunnerUpdateOnly) {
        guard let nextPlayer = gameRunner.players.nextPlayer else {
            return
        }
    
        gameRunner.players.setCurrentPlayer(nextPlayer)
    }
}
