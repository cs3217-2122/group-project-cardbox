//
//  RemoveAllEndTurnActionsEvent.swift
//  CardBox
//
//  Created by Bryann Yeap Kok Keong on 14/3/22.
//

struct RemoveAllEndTurnActionsEvent: GameEvent {
    func updateRunner(gameRunner: GameRunner) {
        gameRunner.removeAllEndTurnActions()
    }
}
