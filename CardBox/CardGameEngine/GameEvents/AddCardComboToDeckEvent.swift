//
//  AddCardComboToDeckEvent.swift
//  CardBox
//
//  Created by Bryann Yeap Kok Keong on 18/3/22.
//

struct AddCardComboToDeckEvent: GameEvent {
    let cardCombo: CardCombo

    func updateRunner(gameRunner: GameRunnerUpdateOnly) {
        gameRunner.deck.addCardCombo(cardCombo)
    }
}
