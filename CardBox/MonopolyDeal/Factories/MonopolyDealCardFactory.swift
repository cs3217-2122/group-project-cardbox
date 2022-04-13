//
//  MonopolyDealCardFactory.swift
//  CardBox
//
//  Created by Stuart Long on 12/4/22.
//

class MonopolyDealCardFactory: CardFactory {
    private init() {

    }

    static func initialiseDeck(gameState: GameState) {
        guard let gameState = gameState as? MonopolyDealGameState else {
            return
        }

        let cards = initCards()
        cards.forEach { card in
            gameState.deck.addCard(card)
        }

        if !CommandLine.arguments.contains("-UITest_MonopolyDeal") {
            gameState.deck.shuffle()
        }
    }

    static func distributeCards(gameState: GameState) {
        guard let gameState = gameState as? MonopolyDealGameState else {
            return
        }

        let numPlayers = 4
        let initialCardCount = 4

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
        }
    }

    private static func initCards() -> [MonopolyDealCard] {
        var cards: [MonopolyDealCard] = []

        let moneyCardValues: [MoneyCardValue] = [.one, .two, .three, .four, .five, .ten]

        for moneyCardValue in moneyCardValues {
            for _ in 0 ..< moneyCardValue.initialFrequency {
                cards.append(MoneyCard(value: moneyCardValue))
            }
        }

        for _ in 0 ..< MonopolyDealCardType.passGo.initialFrequency {
            cards.append(PassGoCard())
        }

        for _ in 0 ..< MonopolyDealCardType.birthday.initialFrequency {
            cards.append(BirthdayCard())
        }

        for _ in 0 ..< MonopolyDealCardType.dealBreaker.initialFrequency {
            cards.append(DealBreakerCard())
        }

        for _ in 0 ..< MonopolyDealCardType.house.initialFrequency {
            cards.append(HouseCard())
        }

        let blueNames = ["Blue 1", "Blue 2", "Blue 3", "Blue 4", "Blue 5"]
        blueNames.forEach { name in
            cards.append(PropertyCard(
                name: name,
                setSize: 3,
                rentAmounts: [100, 400, 500],
                colors: Set([.blue])
            ))
        }

        let redNames = ["Red 1", "Red 2", "Red 3", "Red 4", "Red 5"]
        redNames.forEach { name in
            cards.append(PropertyCard(
                name: name,
                setSize: 3,
                rentAmounts: [200, 300, 700],
                colors: Set([.red])
            ))
        }

        return cards
    }
}

enum MonopolyDealCardType: String, CaseIterable, Codable {
    case property = "property"
    case dealBreaker = "deal_breaker"
    case doubleRent = "double_rent"
    case forcedDeal = "forced_deal"
    case hotel = "hotel"
    case house = "house"
    case birthday = "birthday"
    case passGo = "pass_go"
    case money = "money"
    case debtCollector = "debt_collector"
    case slyDeal = "sly_deal"
    case rent = "rent"

    var initialFrequency: Int {
        switch self {
        case .property:
            return 0
        case .dealBreaker:
            return 2
        case .doubleRent:
            return 2
        case .forcedDeal:
            return 4
        case .hotel:
            return 3
        case .house:
            return 3
        case .birthday:
            return 3
        case .passGo:
            return 10
        case .money:
            return 0
        case .debtCollector:
            return 3
        case .slyDeal:
            return 3
        case .rent:
            return 0
        }
    }
}
