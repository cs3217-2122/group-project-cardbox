//
//  DisplayTopNCardsEvent.swift
//  CardBox
//
//  Created by Bryann Yeap Kok Keong on 1/4/22.
//

struct DisplayTopNCardsEvent: GameEvent {
    let n: Int
    let deck: CardCollection

    func updateRunner(gameRunner: GameRunnerProtocol) {
        guard let ekGameRunner = gameRunner as? ExplodingKittensGameRunnerProtocol else {
            return
        }

        let displayedCards = deck.getTopNCards(n: 3)
        ekGameRunner.setCardsPeeking(cards: displayedCards)
    }
}
