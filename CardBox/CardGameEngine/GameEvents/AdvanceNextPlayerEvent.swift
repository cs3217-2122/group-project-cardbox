//
//  AdvanceNextPlayerEvent.swift
//  CardBox
//
//  Created by Bryann Yeap Kok Keong on 16/3/22.
//

struct AdvanceNextPlayerEvent: GameEvent {

    func updateRunner(gameRunner: GameRunnerUpdateOnly) {
<<<<<<< HEAD
        guard let nextPlayer = gameRunner.players.nextPlayer else {
            return
        }

        gameRunner.players.setCurrentPlayer(nextPlayer)
=======
        gameRunner.players.advanceToNextPlayer()
>>>>>>> f934cefe771b291b2ad8cdd39666a5565116b753
    }
}
