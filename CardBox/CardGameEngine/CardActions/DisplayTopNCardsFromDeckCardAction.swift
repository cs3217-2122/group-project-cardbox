//
//  DisplayTopNCardsFromDeckCardAction.swift
//  CardBox
//
//  Created by mactest on 11/03/2022.
//

struct DisplayTopNCardsFromDeckCardAction: CardAction {
    let n: Int

    func executeGameEvents(gameRunner: GameRunnerReadOnly, args: CardActionArgs) {
        let deck = gameRunner.deck

        let cards = deck.getTopNCards(n: self.n)

        gameRunner.executeGameEvents([
            DisplayCardsEvent(cards: cards)
        ])
    }
}
