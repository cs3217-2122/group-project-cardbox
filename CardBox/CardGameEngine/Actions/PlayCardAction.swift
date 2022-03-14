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
        guard player.canPlay(cards: cards, gameRunner: gameRunner) else {
            // TODO: change to exception
            return
        }

        gameRunner.executeGameEvents([
            IncrementPlayerCardsPlayedEvent(player: player)
        ])

        cards.forEach { card in
            card.onPlay(gameRunner: gameRunner, player: player, on: target)
        }

        let moveCardsEvents = cards.map { card in
            MoveCardPlayerToGameplayEvent(card: card, player: player)
        }

        gameRunner.executeGameEvents(moveCardsEvents
        )
    }
}
