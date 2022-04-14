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
                    let card: Card? = ExplodingKittensCardFactory.getCardFromType(array: array, type: type)
                    if let card = card {
                        items.append(card)
                    }
                }

                return items
            }
        )
    }

}
