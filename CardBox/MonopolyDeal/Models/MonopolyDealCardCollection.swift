//
//  MonopolyDealCardCollection.swift
//  CardBox
//
//  Created by Stuart Long on 15/4/22.
//

class MonopolyDealCardCollection: CardCollection {
    enum ObjectTypeKey: CodingKey {
        case type
    }

    init() {
        super.init(cards: [])
    }

    // TODO: simplify this
    required init(from decoder: Decoder) throws {
        try super.init(
            from: decoder,
            mapFunc: { objectsArray in
                var oriArray = objectsArray
                var items = [Card]()

                var array = objectsArray
                while !oriArray.isAtEnd {
                    guard let object = try? oriArray.nestedContainer(keyedBy: ObjectTypeKey.self) else {
                        continue
                    }
                    guard let type = try? object.decode(MonopolyDealCardType.self,
                                                        forKey: ObjectTypeKey.type) else {
                        continue
                    }
                    let card: Card? = {
                        switch type {
                        case .property:
                            return try? array.decode(PropertyCard.self)
                        case .dealBreaker:
                            return try? array.decode(DealBreakerCard.self)
                        case .doubleRent:
                            // TODO: change
                            return try? array.decode(MonopolyDealCard.self)
                        case .forcedDeal:
                            // TODO: change
                            return try? array.decode(MonopolyDealCard.self)
                        case .hotel:
                            // TODO: change
                            return try? array.decode(MonopolyDealCard.self)
                        case .house:
                            return try? array.decode(HouseCard.self)
                        case .birthday:
                            return try? array.decode(BirthdayCard.self)
                        case .passGo:
                            return try? array.decode(PassGoCard.self)
                        case .money:
                            return try? array.decode(MoneyCard.self)
                        case .debtCollector:
                            // TODO: change
                            return try? array.decode(MonopolyDealCard.self)
                        case .slyDeal:
                            // TODO: change
                            return try? array.decode(MonopolyDealCard.self)
                        case .rent:
                            // TODO: change
                            return try? array.decode(MonopolyDealCard.self)
                        default:
                            return try? array.decode(MonopolyDealCard.self)
                        }
                    }()
                    if let card = card {
                        items.append(card)
                    }
                }

                return items
            }
        )
    }

}
