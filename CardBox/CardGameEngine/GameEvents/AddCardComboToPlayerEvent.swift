//
//  AddCardComboToPlayerEvent.swift
//  CardBox
//
//  Created by Bryann Yeap Kok Keong on 18/3/22.
//

struct AddCardComboToPlayerEvent: GameEvent {
    let player: Player
    let cardCombo: CardCombo

    func updateRunner(gameRunner: GameRunnerUpdateOnly) {
        player.addCardCombo(cardCombo)
    }
}
