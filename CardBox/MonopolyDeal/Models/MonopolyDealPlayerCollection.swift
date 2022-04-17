//
//  MonopolyDealPlayerCollection.swift
//  CardBox
//
//  Created by Stuart Long on 15/4/22.
//

class MonopolyDealPlayerCollection: PlayerCollection {
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
                while !array.isAtEnd {
                    let player: Player? = {
                        try? array.decode(MonopolyDealPlayer.self)
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
