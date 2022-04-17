//
//  MoneyCard.swift
//  CardBox
//
//  Created by Temp on 01.04.2022.
//

enum MoneyCardValue: Int, Codable {
    case ten = 10
    case one = 1
    case two = 2
    case three = 3
    case four = 4
    case five = 5

    var description: String {
        rawValue.description
    }

    var initialFrequency: Int {
        switch self {
        case .ten:
            return 1
        case .five:
            return 2
        case .four:
            return 3
        case .three:
            return 4
        case .two:
            return 5
        case .one:
            return 6
        }
    }
}

class MoneyCard: MonopolyDealCard {
    private let moneyPrefix = "Money "

    let cardValue: MoneyCardValue

    var value: Int {
        cardValue.rawValue
    }

    init(value: MoneyCardValue) {
        self.cardValue = value
        super.init(
            name: moneyPrefix + value.description,
            typeOfTargettedCard: .noTargetCard
        )
    }

    override func onPlay(gameRunner: MDGameRunnerProtocol, player: MDPlayer, on target: GameplayTarget) {
        guard let gameState = gameRunner.gameState as? MonopolyDealGameState else {
            return
        }

        guard let hand = gameState.playerHands[player.id] else {
            return
        }

        guard let moneyArea = gameState.playerMoneyArea[player.id] else {
            return
        }

        gameRunner.executeGameEvents([
            MoveCardsDeckToDeckEvent(cards: [self], fromDeck: hand, toDeck: moneyArea)
        ])
    }

    override func getBankValue() -> Int {
        value
    }

    private enum CodingKeys: String, CodingKey {
        case cardValue
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.cardValue = try container.decode(MoneyCardValue.self, forKey: .cardValue)
        try super.init(from: decoder)
    }

    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(cardValue, forKey: .cardValue)
        try super.encode(to: encoder)
    }
}
