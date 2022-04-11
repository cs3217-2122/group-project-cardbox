//
//  ExplodingKittensCardFactory.swift
//  CardBox
//
//  Created by Stuart Long on 12/4/22.
//

class ExplodingKittensCardFactory: CardFactory {
    private init() {

    }

    static func initialiseDeck(gameState: GameState) {
        guard let gameState = gameState as? ExplodingKittensGameState else {
            return
        }

        let cards = initCards()
        cards.forEach { card in
            gameState.deck.addCard(card)
        }

        if !CommandLine.arguments.contains("-UITest_ExplodingKittens") {
            gameState.deck.shuffle()
        }
    }

    static func distributeCards(gameState: GameState) {
        guard let gameState = gameState as? ExplodingKittensGameState else {
            return
        }
        let numPlayers = 4
        let initialCardCount = 4

        gameState.playerHands.forEach { _, hand in
            let defuseCard = DefuseCard()
            hand.addCard(defuseCard)
        }

        let topCards = gameState.deck.getTopNCards(n: numPlayers * initialCardCount)
        topCards.indices.forEach { i in
            guard let player = gameState.players.getPlayerByIndex(i % numPlayers) else {
                return
            }
            guard let playerDeck = gameState.playerHands[player.id] else {
                return
            }

            gameState.deck.removeCard(topCards[i])
            playerDeck.addCard(topCards[i])
            playerDeck.shuffle()
        }

        let bombs = (1...(numPlayers - 1)).map { _ in
            BombCard()
        }
        bombs.forEach { bomb in
            gameState.deck.addCard(bomb)
        }

        if !CommandLine.arguments.contains("-UITest_ExplodingKittens") {
            gameState.deck.shuffle()
        }

    }

    private static func initCards() -> [ExplodingKittensCard] {
        var cards: [ExplodingKittensCard] = []

        for _ in 0 ..< ExplodingKittensCardType.favor.initialFrequency {
            cards.append(FavorCard())
        }

        for _ in 0 ..< ExplodingKittensCardType.attack.initialFrequency {
            cards.append(AttackCard())
        }

        for _ in 0 ..< ExplodingKittensCardType.shuffle.initialFrequency {
            cards.append(ShuffleCard())
        }

        for _ in 0 ..< ExplodingKittensCardType.skip.initialFrequency {
            cards.append(SkipCard())
        }

        for _ in 0 ..< ExplodingKittensCardType.seeTheFuture.initialFrequency {
            cards.append(SeeTheFutureCard())
        }

        for _ in 0 ..< ExplodingKittensCardType.random1.initialFrequency {
            cards.append(RandomCard(name: "Random 1", type: .random1))
            cards.append(RandomCard(name: "Random 2", type: .random2))
            cards.append(RandomCard(name: "Random 3", type: .random3))
        }

        return cards
    }
}

enum ExplodingKittensCardType: String, CaseIterable, Codable {
    case attack = "attack"
    case bomb = "bomb"
    case defuse = "defuse"
    case favor = "favor"
    case nope = "nope"
    case seeTheFuture = "see-the-future"
    case shuffle = "shuffle"
    case skip = "skip"
    case random1 = "random-1"
    case random2 = "random-2"
    case random3 = "random-3"

    var initialFrequency: Int {
        switch self {
        case .attack:
            return 4
        case .favor:
            return 4
        case .nope:
            return 5
        case .seeTheFuture:
            return 5
        case .shuffle:
            return 4
        case .skip:
            return 4
        case .random1, .random2, .random3:
            return 4
        case .bomb, .defuse:
            return 0
        }
    }
}
