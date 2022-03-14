//
//  ExplodingKittensGameRunner.swift
//  CardBox
//
//  Created by mactest on 11/03/2022.
//

class ExplodingKittensGameRunner {
    let gameRunner: GameRunner

    init() {
        self.gameRunner = GameRunner()
        initGameRunner()
    }

    func initGameRunner() {
        let cards = initCards()
        gameRunner.addSetupAction(InitDeckWithCardsAction(cards: cards))
        gameRunner.addSetupAction(InitPlayerAction(numPlayers: 4))
        gameRunner.addSetupAction(ShuffleDeckAction())
        gameRunner.addSetupAction(DistributeCardsToPlayerAction(numCards: 2))

        gameRunner.addEndTurnAction(DrawCardFromDeckToCurrentPlayerAction(target: .currentPlayer))
    }

    func generateBombCard() -> Card {
        let card = Card(name: "Bomb")
        card.addDrawAction(PlayerOutOfGameAction())
        return card
    }

    func generateSeeTheFutureCard() -> Card {
        let card = Card(name: "See The Future")
        card.addPlayAction(DisplayTopNCardsFromDeckCardAction(n: 3))
        return card
    }

    func initCards() -> [Card] {
        var cards: [Card] = []

        for _ in 0...5 {
            cards.append(generateBombCard())
        }

        for _ in 0...10 {
            cards.append(generateSeeTheFutureCard())
        }

        return cards
    }
}
