//
//  ExplodingKittensCardAdapter.swift
//  CardBox
//
//  Created by Stuart Long on 1/4/22.
//

class ExplodingKittensCardAdapter: CardAdapter {
    let type: ExplodingKittensCardType

    init(explodingKittensCard: ExplodingKittensCard) {
        self.type = explodingKittensCard.type
    }

    var ekCard: ExplodingKittensCard {
        if type == .attack {
            return AttackCard()
        } else if type == .bomb {
            return BombCard()
        } else if type == .defuse {
            return DefuseCard()
        } else if type == .favor {
            return FavorCard()
        } else if type == .nope {
            // use a random card first since nope not implemented yet
            return RandomCard(name: "Random 3", type: .random3)
        } else if type == .seeTheFuture {
            return SeeTheFutureCard()
        } else if type == .shuffle {
            return ShuffleCard()
        } else if type == .skip {
            return SkipCard()
        } else if type == .random1 {
            return RandomCard(name: "Random 1", type: .random1)
        } else if type == .random2 {
            return RandomCard(name: "Random 2", type: .random2)
        } else {
            return RandomCard(name: "Random 3", type: .random3)
        }
    }

    private enum CodingKeys: String, CodingKey {
        case type
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.type = try container.decode(ExplodingKittensCardType.self, forKey: .type)
//        super.init()
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
    }
}
