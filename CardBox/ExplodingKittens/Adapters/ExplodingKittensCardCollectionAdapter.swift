//
//  ExplodingKittensCardCollectionAdapter.swift
//  CardBox
//
//  Created by Stuart Long on 1/4/22.
//

class ExplodingKittensCardCollectionAdapter: CardCollectionAdapter, Codable {
    private var cards: [ExplodingKittensCardAdapter]

    var cardCollection: EKCardCollection {
        let output = EKCardCollection()
        for card in cards {
            output.addCard(card.ekCard)
        }
        return output
    }

    init(_ cardCollection: EKCardCollection) {
        let cards = cardCollection.getCards()
        self.cards = []
        for card in cards {
            guard let card = card as? ExplodingKittensCard else {
                continue
            }
            self.cards
                .append(ExplodingKittensCardAdapter(explodingKittensCard: card))
        }
    }
}
