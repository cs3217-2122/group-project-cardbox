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
        print("executing")
        for comboAction in comboActions {
            comboAction.executeGameEvents(gameRunner: gameRunner,
                                          args: CardActionArgs(card: nil, player: player, target: target))
        }

        let allCardsEvents = cards.flatMap({ card in
                [IncrementPlayerCardsPlayedEvent(player: player),
                MoveCardPlayerToGameplayEvent(card: card, player: player)]
        })

        print(allCardsEvents.count)

        if let allCardsEvents = allCardsEvents as? [GameEvent] {
            gameRunner.executeGameEvents(allCardsEvents)
        }
    }
}
