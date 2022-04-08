//
//  ExplodingKittensCardAdapter.swift
//  CardBox
//
//  Created by Stuart Long on 1/4/22.
//
import Foundation

class ExplodingKittensCardAdapter: CardAdapter {
    let id: UUID
    let type: ExplodingKittensCardType

    init(explodingKittensCard: ExplodingKittensCard) {
        self.id = explodingKittensCard.id
        self.type = explodingKittensCard.type
    }

    var ekCard: ExplodingKittensCard {
        if type == .attack {
            return AttackCard(id: id)
        } else if type == .bomb {
            return BombCard(id: id)
        } else if type == .defuse {
            return DefuseCard(id: id)
        } else if type == .favor {
            return FavorCard(id: id)
        } else if type == .nope {
            // use a random card first since nope not implemented yet
            return RandomCard(id: id, name: "Random 3", type: .random3)
        } else if type == .seeTheFuture {
            return SeeTheFutureCard(id: id)
        } else if type == .shuffle {
            return ShuffleCard(id: id)
        } else if type == .skip {
            return SkipCard(id: id)
        } else if type == .random1 {
            return RandomCard(id: id, name: "Random 1", type: .random1)
        } else if type == .random2 {
            return RandomCard(id: id, name: "Random 2", type: .random2)
        } else {
            return RandomCard(id: id, name: "Random 3", type: .random3)
        }
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case type
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.type = try container.decode(ExplodingKittensCardType.self, forKey: .type)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(type, forKey: .type)
    }
}
