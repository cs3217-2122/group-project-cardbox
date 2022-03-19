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
            guard player.canPlay(cards: cards, gameRunner: gameRunner) else {
                continue
            }

            card.onPlay(gameRunner: gameRunner, player: player, on: target)

            gameRunner.executeGameEvents([
                IncrementPlayerCardsPlayedEvent(player: player),
                MoveCardPlayerToGameplayEvent(card: card, player: player)
            ])
        }
    }
}
