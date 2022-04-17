//
//  ExplodingKittensPlayerCollection.swift
//  CardBox
//
//  Created by Stuart Long on 14/4/22.
//

class ExplodingKittensPlayerCollection: PlayerCollection {
    init() {
        super.init(players: [])
    }

    required init(from decoder: Decoder) throws {
        try super.init(
            from: decoder,
            mapFunc: { objectsArray in
                var items = [Player]()

                var array = objectsArray
                while !array.isAtEnd {
                    let player: Player? = {
                        try? array.decode(ExplodingKittensPlayer.self)
                    }()
                    if let player = player {
                        items.append(player)
                    }
                }

                return items
            }
        )
    }
}
