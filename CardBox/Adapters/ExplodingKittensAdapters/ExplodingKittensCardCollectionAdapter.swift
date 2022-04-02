//
//  ExplodingKittensCardCollectionAdapter.swift
//  CardBox
//
//  Created by Stuart Long on 1/4/22.
//

class ExplodingKittensCardCollectionAdapter: CardCollectionAdapter {
    private var cards: [ExplodingKittensCardAdapter]

    var cardCollection: CardCollection {
        let output = CardCollection()
        for card in cards {
            output.addCard(card.ekCard)
        }
        return output
    }

    init(_ cardCollection: CardCollection) {
        let cards = cardCollection.getCards()
        self.cards = []
        for card in cards {
            guard let card = card as? ExplodingKittensCard else {
                continue
            }
            self.cards
                .append(ExplodingKittensCardAdapter(explodingKittensCard: card))
        }
        super.init()
    }

    private enum CodingKeys: String, CodingKey {
        case cards
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.cards = try container.decode([ExplodingKittensCardAdapter].self, forKey: .cards)
        super.init()
    }

    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(cards, forKey: .cards)
    }
}
