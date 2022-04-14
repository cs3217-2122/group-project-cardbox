//
//  ExplodingKittensCardCollection.swift
//  CardBox
//
//  Created by user213938 on 4/13/22.
//

class ExplodingKittensCardCollection: CardCollection {
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
                    guard let type = try? object.decode(ExplodingKittensCardType.self,
                                                        forKey: ObjectTypeKey.type) else {
                        continue
                    }
                    let card: Card? = {
                        switch type {
                        case .attack:
                            return try? array.decode(AttackCard.self)
                        case .bomb:
                            return try? array.decode(BombCard.self)
                        case .defuse:
                            return try? array.decode(DefuseCard.self)
                        case .favor:
                            return try? array.decode(FavorCard.self)
                        case .seeTheFuture:
                            return try? array.decode(SeeTheFutureCard.self)
                        case .shuffle:
                            return try? array.decode(ShuffleCard.self)
                        case .skip:
                            return try? array.decode(SkipCard.self)
                        case .random1, .random2, .random3:
                            return try? array.decode(RandomCard.self)
                        default:
                            return try? array.decode(ExplodingKittensCard.self)
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
