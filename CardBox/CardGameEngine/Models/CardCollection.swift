//
//  CardCollection.swift
//  CardBox
//
//  Created by mactest on 10/03/2022.
//

class CardCollection: Identifiable, Codable {
    internal var cards: [Card] = []

    // TODO: initialise with correct value
    var isFaceUp = true

    init(cards: [Card]) {
        self.cards = cards
    }

    enum CodingKeys: CodingKey {
        case cards
    }

    enum ObjectTypeKey: CodingKey {
        case type
    }

    init<T: Decodable>(from decoder: Decoder, mapFunc: (Decoder, T) -> Card?, cardType: T.Type) throws {
        // TODO
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let objectsArray = try container.nestedUnkeyedContainer(forKey: CodingKeys.cards)
        var oriArray = objectsArray
        var items = [Card]()

        while !oriArray.isAtEnd {
            // Need to call decode at least once here to advance the pointer
            guard let object = try? oriArray.nestedContainer(keyedBy: ObjectTypeKey.self) else {
                continue
            }
            guard let type = try? object.decode(T.self, forKey: .type) else {
                continue
            }

            let decoder = try object.superDecoder()
            let card: Card? = mapFunc(decoder, type)
            if let card = card {
                items.append(card)
            }
        }

        self.cards = items
    }

    func encode<T: Codable>(to encoder: Encoder, mapFunc: (Card) -> T?, cardType: T.Type) {
        var container = encoder.container(keyedBy: CodingKeys.self)
        var objectsArray = container.nestedUnkeyedContainer(forKey: CodingKeys.cards)
        cards.forEach { item in
            guard let type = mapFunc(item) else {
                return
            }

            var object = objectsArray.nestedContainer(keyedBy: ObjectTypeKey.self)

            try? object.encode(type, forKey: ObjectTypeKey.type)

            let encoder = object.superEncoder()
            try? item.encode(to: encoder)
        }
    }

    convenience init() {
        self.init(cards: [])
    }

    var count: Int {
        cards.count
    }

    var topCard: Card? {
        if cards.isEmpty {
            return nil
        }
        return cards.first
    }

    var bottomCard: Card? {
        if cards.isEmpty {
            return nil
        }
        return cards.last
    }

    var isEmpty: Bool {
        cards.isEmpty
    }

    func updateState(_ cardCollection: CardCollection) {
        self.cards = cardCollection.cards
    }

    func getCardByIndex(_ index: Int) -> Card? {
        guard index >= 0 && index < cards.count else {
            return nil
        }

        return cards[index]
    }

    func getTopNCards(n: Int) -> [Card] {
        guard n > 0 else {
            return []
        }

        return Array(cards[0..<min(cards.count, n)])
    }

    func removeCard(_ card: Card) {
        guard let cardIndex = cards.firstIndex(where: { $0.isEqual(card) }) else {
            return
        }
        cards.remove(at: cardIndex)
    }

    func removeCards(_ cards: [Card]) {
        for card in cards {
            removeCard(card)
        }
    }

    func addCard(_ card: Card) {
        guard !containsCard(card) else {
            return
        }

        cards.append(card)
    }

    func addCard(_ card: Card, offsetFromTop index: Int) {
        guard !containsCard(card) else {
            return
        }

        // Ensures that add card always add back to the deck
        let actualIndex = max(0, min(index, cards.count))

        cards.insert(card, at: actualIndex)
    }

    func addCards(_ cards: [Card], offsetFromTop index: Int) {
        for card in cards {
            addCard(card, offsetFromTop: index)
        }
    }

    func containsCard(_ card: Card) -> Bool {
        containsCard(where: { $0 === card })
    }

    func containsCard(where predicate: (Card) -> Bool) -> Bool {
        cards.contains(where: predicate)
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

    func shuffle() {
        self.cards.shuffle()
    }

    func canAdd(_ card: Card) -> Bool {
        true
    }
}
