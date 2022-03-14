//
//  AddEndTurnActionsEvent.swift
//  CardBox
//
//  Created by Bryann Yeap Kok Keong on 14/3/22.
//

struct AddEndTurnActionsEvent: GameEvent {
    let onEndTurnActions: [Action]

    func updateRunner(gameRunner: GameRunner) {
        for onEndTurnAction in onEndTurnActions {
            gameRunner.addEndTurnAction(onEndTurnAction)
        }
    }
}
