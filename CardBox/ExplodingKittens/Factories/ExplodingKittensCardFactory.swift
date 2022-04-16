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
            cards.append(RandomCard(name: "Random 1", cardType: .random1))
            cards.append(RandomCard(name: "Random 2", cardType: .random2))
            cards.append(RandomCard(name: "Random 3", cardType: .random3))
        }

        return cards
    }

    private static func getCardTypeFromObject_1(card: ExplodingKittensCard) -> ExplodingKittensCardType? {
        switch card {
        case is AttackCard:
            return .attack
        case is BombCard:
            return .bomb
        case is DefuseCard:
            return .defuse
        case is FavorCard:
            return .favor
        case is SeeTheFutureCard:
            return .seeTheFuture
        default:
            return nil
        }
    }

    private static func getCardTypeFromObject_2(card: ExplodingKittensCard) -> ExplodingKittensCardType? {
        switch card {
        case is ShuffleCard:
            return .shuffle
        case is SkipCard:
            return .skip
        case is RandomCard:
            guard let rCard = card as? RandomCard else {
                return nil
            }
            switch rCard.randomCardType {
            case .random1:
                return .random1
            case .random2:
                return .random2
            case .random3:
                return .random3
            }
        default:
            return nil
        }
    }

    static func getCardTypeFromObject(card: ExplodingKittensCard) -> ExplodingKittensCardType? {
        let type1 = ExplodingKittensCardFactory.getCardTypeFromObject_1(card: card)
        if type1 != nil {
            return type1
        }

        let type2 = ExplodingKittensCardFactory.getCardTypeFromObject_2(card: card)
        return type2
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

    var metatype: ExplodingKittensCard.Type? {
        switch self {
        case .attack:
            return AttackCard.self
        case .favor:
            return FavorCard.self
        case .nope:
            return nil
        case .seeTheFuture:
            return SeeTheFutureCard.self
        case .shuffle:
            return ShuffleCard.self
        case .skip:
            return SkipCard.self
        case .random1, .random2, .random3:
            return RandomCard.self
        case .bomb:
            return BombCard.self
        case .defuse:
            return DefuseCard.self
        }
    }
}
