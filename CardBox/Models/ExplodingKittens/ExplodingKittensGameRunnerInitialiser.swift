//
//  ExplodingKittensGameRunnerInitialiser.swift
//  CardBox
//
//  Created by mactest on 11/03/2022.
//

class ExplodingKittensGameRunnerInitialiser: GameRunnerInitialiser {

    private init() {
    }

    static func initialiseGameRunner() -> GameRunner {
        let gameRunner = GameRunner()
        let cards = initCards()

        gameRunner.addSetupAction(InitDeckWithCardsAction(cards: cards))
        gameRunner.addSetupAction(InitPlayerAction(numPlayers: 4))
        gameRunner.addSetupAction(ShuffleDeckAction())
        gameRunner.addSetupAction(DistributeCardsToPlayerAction(numCards: 2))

        gameRunner.addEndTurnAction(DrawCardFromDeckToCurrentPlayerAction(target: .currentPlayer))
        
        ActionDispatcher.runAction(SetupGameAction(), on: gameRunner)
        
        return gameRunner
    }

    private static func generateBombCard() -> Card {
        let card = Card(name: "Bomb")
        let isTrueCardActions: [CardAction] = [
            PlayerDiscardCardAction(cardToDiscard: generateDefuseCard()),
            PlayerInsertCardIntoDeckCardAction(card: card, offsetFromTop: 0)
        ]
        let isFalseCardActions = [PlayerOutOfGameCardAction()]

        card.addDrawAction(ConditionalCardAction(condition: { _, player, _ in
            player.hasCard(generateDefuseCard())
        }, isTrueCardActions: isTrueCardActions, isFalseCardActions: isFalseCardActions))
        return card
    }
     
    private static func generateSeeTheFutureCard() -> Card {
        let card = Card(name: "See The Future")
        card.addPlayAction(DisplayTopNCardsFromDeckCardAction(n: 3))
        return card
    }

    private static func generateShuffleCard() -> Card {
        let card = Card(name: "Shuffle")
        card.addPlayAction(ShuffleDeckCardAction())
        return card
    }
    
    private static func generateSkipCard() -> Card {
        let card = Card(name: "Skip")
        card.addPlayAction(EndTurnWithoutActionsCardAction())
        return card
    }

    private static func generateDefuseCard() -> Card {
        let card = Card(name: "Defuse")
        return card
    }

    private static func initCards() -> [Card] {
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
