//
//  PropertyCard.swift
//  CardBox
//
//  Created by user213938 on 4/3/22.
//

enum PropertyColor: Int, Codable {
    case red
    case blue
    case green
}

class PropertyCard: MonopolyDealCard {
    let setSize: Int
    let rentAmounts: [Int]
    let colors: Set<PropertyColor>

    init(name: String, setSize: Int, rentAmounts: [Int], colors: Set<PropertyColor>) {
        self.setSize = setSize
        self.rentAmounts = rentAmounts
        self.colors = colors
        super.init(
            name: name,
            typeOfTargettedCard: .targetSingleDeckCard,
            type: .property
        )
    }

    func getRentForSetSize(size: Int) -> Int {
        guard size < rentAmounts.count && size >= 0 else {
            return 0
        }

        return rentAmounts[size - 1]
    }

    override func onPlay(gameRunner: MDGameRunnerProtocol, player: MDPlayer, on target: GameplayTarget) {
        if case .deck(let deck) = target {
            if let deck = deck {
                let hand = gameRunner.getHandByPlayer(player)

                guard let baseCard = deck.getCardByIndex(0) as? PropertyCard else {
                    return
                }

                let baseColors = baseCard.colors

                guard baseColors.count == 1 else {
                    return
                }
                guard let baseColor = baseColors.first else {
                    return
                }

                let baseSize = baseCard.setSize
                guard deck.count < baseSize else {
                    return
                }

                if self.colors.contains(baseColor) {
                    gameRunner.executeGameEvents([
                        MoveCardsDeckToDeckEvent(cards: [self], fromDeck: hand, toDeck: deck)
                    ])
                }
            } else {
                let hand = gameRunner.getHandByPlayer(player)

                guard colors.count == 1 else {
                    return
                }

                let newCollection = CardCollection()
                newCollection.addCard(self)

                let propertyArea = gameRunner.getPropertyAreaByPlayer(player)
                gameRunner.executeGameEvents([
                    AddNewPropertyAreaEvent(propertyArea: propertyArea, cards: newCollection, fromHand: hand)
                ])
            }
        }
    }

    private enum CodingKeys: String, CodingKey {
        case setSize
        case rentAmounts
        case colors
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.setSize = try container.decode(Int.self, forKey: .setSize)
        self.rentAmounts = try container.decode([Int].self, forKey: .rentAmounts)
        self.colors = try container.decode(Set<PropertyColor>.self, forKey: .colors)
        try super.init(from: decoder)
    }

    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(setSize, forKey: .setSize)
        try container.encode(rentAmounts, forKey: .rentAmounts)
        try container.encode(colors, forKey: .colors)
//        let superEncoder = container.superEncoder()
        try super.encode(to: encoder)
    }
}
