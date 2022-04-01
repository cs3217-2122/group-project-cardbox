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
        super.init()
    }

    private enum CodingKeys: String, CodingKey {
        case type
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.type = try container.decode(ExplodingKittensCardType.self, forKey: .type)
        super.init()
    }
}
