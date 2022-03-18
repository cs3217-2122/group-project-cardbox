//
//  PlayCardAction.swift
//  CardBox
//
//  Created by mactest on 12/03/2022.
//

struct PlayCardAction: Action {
    let player: Player
    let cards: [Card]
    let target: GameplayTarget

    func executeGameEvents(gameRunner: GameRunnerReadOnly) {

        for card in cards {
            guard card.canPlay(by: player, gameRunner: gameRunner, on: target) else {
                continue
            }
            
            card.onPlay(gameRunner: gameRunner, player: player, on: target)

            gameRunner.executeGameEvents([
                IncrementPlayerCardsPlayedEvent(player: player)
            ])
        }

        let moveCardsEvents = cards.map { card in
            MoveCardPlayerToGameplayEvent(card: card, player: player)
        }

        gameRunner.executeGameEvents(moveCardsEvents)
    }
}
