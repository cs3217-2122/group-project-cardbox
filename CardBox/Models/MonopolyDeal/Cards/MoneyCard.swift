//
//  MoneyCard.swift
//  CardBox
//
//  Created by Temp on 01.04.2022.
//

enum MoneyCardValue: Int {
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
    let cardValue: MoneyCardValue

    var value: Int {
        cardValue.rawValue
    }

    init(value: MoneyCardValue) {
        self.cardValue = value
        super.init(
            name: "Money " + value.description,
            typeOfTargettedCard: .noTargetCard,
            type: .money
        )
    }

    override func onPlay(gameRunner: MDGameRunnerProtocol, player: MDPlayer, on target: GameplayTarget) {
        guard let hand = gameRunner.playerHands[player.id] else {
            return
        }

        guard let moneyArea = gameRunner.playerMoneyArea[player.id] else {
            return
        }

        gameRunner.executeGameEvents([
            MoveCardsDeckToDeckEvent(cards: [self], fromDeck: hand, toDeck: moneyArea)
        ])
    }
}
