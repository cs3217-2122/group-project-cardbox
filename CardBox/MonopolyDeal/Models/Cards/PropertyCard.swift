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

    var setSize: Int {
        switch self {
        default:
            return 3
        }
    }
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
            typeOfTargettedCard: .targetSingleDeckCard
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
                guard deck.getCards().filter({ $0 is PropertyCard }).count < baseSize else {
                    return
                }

                if self.colors.contains(baseColor) {
                    // gameRunner.executeGameEvents([
                    //    MoveCardsDeckToDeckEvent(cards: [self], fromDeck: hand, toDeck: deck)
                    // ])
                }
            } else {
                let hand = gameRunner.getHandByPlayer(player)

                guard colors.count == 1 else {
                    return
                }

                // let newCollection = MonopolyDealPropertySet(cards: [self], setColour: colors.first ?? .red)

                let propertyArea = gameRunner.getPropertyAreaByPlayer(player)
                gameRunner.executeGameEvents([
                    AddNewPropertyAreaEvent(propertyArea: propertyArea, card: self, fromHand: hand)
                ])
            }
        }
    }

    override func getBankValue() -> Int {
        // TODO: ADD BANK VALUE WHEN MORE COLORS ARE ADDED
        if colors.contains(.green) || colors.contains(.blue) {
            return 4
        } else if colors.contains(.red) {
            return 3
        } else {
            assert(false, "Unable to obtain bank value of property card")
        }
    }

    func getStringRepresentationOfColors() -> String {
        var colorsString = ""
        let colors = Array(self.colors)
        for i in 0 ..< colors.count {
            let color = colors[i]
            colorsString += "\(color)"
            if i != colors.count - 1 {
                colorsString += ", "
            }
        }
        return colorsString
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
