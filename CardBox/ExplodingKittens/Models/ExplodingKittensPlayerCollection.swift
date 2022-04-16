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

    // TODO: simplify this
    required init(from decoder: Decoder) throws {
        try super.init(
            from: decoder,
            mapFunc: { objectsArray in
                let oriArray = objectsArray
                var items = [Player]()

                var array = objectsArray
                while !oriArray.isAtEnd {
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

//    required init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        let players = try container.decode([ExplodingKittensPlayer].self, forKey: .players)
//        let currentPlayerIndex = try container.decode(Int.self, forKey: .currentPlayerIndex)
//        super.init(players: players, currentPlayerIndex: currentPlayerIndex)
//    }
}
