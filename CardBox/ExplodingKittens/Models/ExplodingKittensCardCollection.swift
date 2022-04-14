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

                let array = objectsArray
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
                            return try? arrayCopy.decode(AttackCard.self)
                        case .bomb:
                            return try? arrayCopy.decode(BombCard.self)
                        case .defuse:
                            return try? arrayCopy.decode(DefuseCard.self)
                        case .favor:
                            return try? arrayCopy.decode(FavorCard.self)
                        case .seeTheFuture:
                            return try? arrayCopy.decode(SeeTheFutureCard.self)
                        case .shuffle:
                            return try? arrayCopy.decode(ShuffleCard.self)
                        case .skip:
                            return try? arrayCopy.decode(SkipCard.self)
                        case .random1, .random2, .random3:
                            return try? arrayCopy.decode(RandomCard.self)
                        default:
                            return try? arrayCopy.decode(ExplodingKittensCard.self)
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
