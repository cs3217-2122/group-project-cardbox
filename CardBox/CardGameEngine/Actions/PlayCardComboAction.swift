//
//  PlayCardComboAction.swift
//  CardBox
//
//  Created by Bryann Yeap Kok Keong on 18/3/22.
//

struct PlayCardComboAction: Action {
    let player: Player
    let cards: [Card]
    let target: GameplayTarget
    let comboActions: [CardAction]

    func executeGameEvents(gameRunner: GameRunnerReadOnly) {
        
        for comboAction in comboActions {
            comboAction.executeGameEvents(gameRunner: gameRunner,
                                          args: CardActionArgs(card: nil, player: player, target: target))
        }

        let allCardsEvents = cards.compactMap({ card in
            [
                IncrementPlayerCardsPlayedEvent(player: player),
                MoveCardPlayerToGameplayEvent(card: card, player: player)
            ]
        })
        
        if let allCardsEvents = allCardsEvents as? [GameEvent] {
            gameRunner.executeGameEvents(allCardsEvents)
        }
    }
}
