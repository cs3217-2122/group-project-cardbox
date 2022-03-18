//
//  CardCollection.swift
//  CardBox
//
//  Created by mactest on 10/03/2022.
//

typealias CardCombo = (_ cards: [Card]) -> [CardAction]

class CardCollection {
    private var cards: [Card] = []
    private var cardCombos: [CardCombo] = []

    var count: Int {
        cards.count
    }

    func addCardCombo(_ cardCombo: @escaping CardCombo) {
        self.cardCombos.append(cardCombo)
    }

    func getSize() -> Int {
        cards.count
    }

    func getFirstCard() -> Card? {
        if cards.isEmpty {
            return nil
        }
        return cards[0]
    }

    func getCardByIndex(_ index: Int) -> Card? {
        if index < 0 || index >= cards.count {
            return nil
        }

        return cards[index]
    }

    func getTopNCards(n: Int) -> [Card] {
        Array(cards[0..<min(cards.count, n)])
    }

    func removeCard(_ card: Card) {
        guard let cardIndex = cards.firstIndex(where: { $0 === card }) else {
            return
        }
        cards.remove(at: cardIndex)
    }

    func addCard(_ card: Card) {
        cards.append(card)
    }

    func addCard(_ card: Card, offsetFromTop index: Int) {
        cards.insert(card, at: index)
    }

    func containsCard(_ card: Card) -> Bool {
        containsCard(where: { $0 === card })
    }

    func getCards() -> [Card] {
        self.cards
    }
    
    func getCard(where predicate: (Card) -> Bool) -> Card? {
        for card in cards {
            if predicate(card) {
                return card
            }
        }
        return nil
    }

    func containsCard(where predicate: (Card) -> Bool) -> Bool {
        cards.contains(where: predicate)
    }

    func shuffle() {
        self.cards.shuffle()
    }
    
    func contains(card: Card) -> Bool {
        self.cards.contains { cardObject in
            cardObject === card
        }
    }
    
    func determineCardComboActions(_ cards: [Card]) -> [CardAction] {
        var cardComboActions: [CardAction] = []
        
        for getCardCombo in cardCombos {
            cardComboActions.append(contentsOf: getCardCombo(cards))
        }
        
        return cardComboActions
    }
}
