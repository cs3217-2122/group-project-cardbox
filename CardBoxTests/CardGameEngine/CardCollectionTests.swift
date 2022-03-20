//
//  CardCollectionTests.swift
//  CardBoxTests
//
//  Created by mactest on 19/03/2022.
//

import XCTest
@testable import CardBox

class CardCollectionTests: XCTestCase {
    func test_emptyCollection() throws {
        let collection = CardCollection()

        XCTAssert(collection.isEmpty)
        XCTAssert(collection.topCard == nil)
    }

    func test_singleCard() {
        let collection = CardCollection()

        let card1 = Card(name: "card 1")
        collection.addCard(card1)

        XCTAssert(!collection.isEmpty)
        XCTAssert(collection.count == 1)
        XCTAssert(collection.topCard === card1)
    }

    func test_getCardByIndex() {
        let collection = CardCollection()

        let card1 = Card(name: "card 1")
        let card2 = Card(name: "card 2")

        collection.addCard(card1)
        collection.addCard(card2)

        XCTAssert(collection.getCardByIndex(0) === card1)
        XCTAssert(collection.getCardByIndex(1) === card2)
    }

    func test_getCardByIndex_outOfBounds() {
        let collection = CardCollection()

        let card1 = Card(name: "card 1")
        let card2 = Card(name: "card 2")

        collection.addCard(card1)
        collection.addCard(card2)

        let outOfBoundCard1 = collection.getCardByIndex(3)
        XCTAssert(outOfBoundCard1 == nil)

        let outOfBoundCard2 = collection.getCardByIndex(-1)
        XCTAssert(outOfBoundCard2 == nil)
    }

    func test_getTopNCards() {
        let collection = CardCollection()

        let card1 = Card(name: "card 1")
        let card2 = Card(name: "card 2")
        let card3 = Card(name: "card 3")

        collection.addCard(card1)
        collection.addCard(card2)
        collection.addCard(card3)

        let topZeroCard = collection.getTopNCards(n: 0)
        XCTAssert(topZeroCard.isEmpty)

        let topOneCard = collection.getTopNCards(n: 1)
        XCTAssert(topOneCard.count == 1)
        XCTAssert(topOneCard[0] === card1)

        let topTwoCards = collection.getTopNCards(n: 2)
        XCTAssert(topTwoCards.count == 2)
        XCTAssert(topTwoCards[0] === card1)
        XCTAssert(topTwoCards[1] === card2)

        let topThreeCards = collection.getTopNCards(n: 3)
        XCTAssert(topThreeCards.count == 3)
        XCTAssert(topThreeCards[0] === card1)
        XCTAssert(topThreeCards[1] === card2)
        XCTAssert(topThreeCards[2] === card3)
    }

    func test_getTopNCards_negativeN() {
        let collection = CardCollection()

        let card1 = Card(name: "card 1")
        let card2 = Card(name: "card 2")
        let card3 = Card(name: "card 3")

        collection.addCard(card1)
        collection.addCard(card2)
        collection.addCard(card3)

        let topNegativeCard = collection.getTopNCards(n: -1)
        XCTAssert(topNegativeCard.isEmpty)
    }

    func test_getTopNCards_outOfBoundsN() {
        let collection = CardCollection()

        let card1 = Card(name: "card 1")
        let card2 = Card(name: "card 2")
        let card3 = Card(name: "card 3")

        collection.addCard(card1)
        collection.addCard(card2)
        collection.addCard(card3)

        let topOutOfBoundCards = collection.getTopNCards(n: 5)
        XCTAssert(topOutOfBoundCards.count == 3)
        XCTAssert(topOutOfBoundCards[0] === card1)
        XCTAssert(topOutOfBoundCards[1] === card2)
        XCTAssert(topOutOfBoundCards[2] === card3)
    }

    func test_addCard_duplicate() {
        let collection = CardCollection()

        let card1 = Card(name: "card 1")

        collection.addCard(card1)
        collection.addCard(card1)

        XCTAssert(collection.count == 1)
    }

    func test_addCardWithOffset_duplicate() {
        let collection = CardCollection()

        let card1 = Card(name: "card 1")

        collection.addCard(card1, offsetFromTop: 0)
        collection.addCard(card1, offsetFromTop: 0)

        XCTAssert(collection.count == 1)
    }

    func test_addCardWithOffset_outOfBoundIndex() {
        let collection = CardCollection()

        let card1 = Card(name: "card 1")
        let card2 = Card(name: "card 2")

        collection.addCard(card1)
        collection.addCard(card2)

        let card3 = Card(name: "card 3")
        collection.addCard(card3, offsetFromTop: 5)
        XCTAssert(collection.count == 3)
        XCTAssert(collection.getCardByIndex(2) === card3)

        let card4 = Card(name: "card 4")
        collection.addCard(card4, offsetFromTop: -1)
        XCTAssert(collection.count == 4)
        XCTAssert(collection.getCardByIndex(0) === card4)
    }

    func test_containsCard() {
        let collection = CardCollection()

        let card1 = Card(name: "card 1")
        let card2 = Card(name: "card 2")

        collection.addCard(card1)
        collection.addCard(card2)

        XCTAssert(collection.containsCard(card1))

        let card3 = Card(name: "card 3")
        XCTAssert(!collection.containsCard(card3))
    }

    func test_containsCardWhere() {
        let collection = CardCollection()

        let card1 = Card(name: "card 1")
        let card2 = Card(name: "card 2")

        collection.addCard(card1)
        collection.addCard(card2)

        XCTAssert(collection.containsCard(where: { $0.name == "card 1" }))

        XCTAssert(!collection.containsCard(where: { $0.name == "card 0" }))
    }

    func test_containsCardWhere_multipleMatch() {
        let collection = CardCollection()

        let card1 = Card(name: "card 1")
        let card2 = Card(name: "card 1")

        collection.addCard(card1)
        collection.addCard(card2)

        XCTAssert(collection.containsCard(where: { $0.name == "card 1" }))
    }

    func test_getCardWhere() {
        let collection = CardCollection()

        let card1 = Card(name: "card 1")
        let card2 = Card(name: "card 2")

        collection.addCard(card1)
        collection.addCard(card2)

        XCTAssert(collection.getCard(where: { $0.name == "card 1" }) === card1)

        XCTAssert(collection.getCard(where: { $0.name == "card 0" }) == nil)
    }

    func test_getCardWhere_multipleMatch() {
        let collection = CardCollection()

        let card1 = Card(name: "card 1")
        let card2 = Card(name: "card 1")

        collection.addCard(card1)
        collection.addCard(card2)

        XCTAssert(collection.getCard(where: { $0.name == "card 1" }) === card1)
    }

    // Probability of this failing is very low
    func test_shuffle() {
        let collection = CardCollection()

        let cards = (1...20).map {
            Card(name: "card " + $0.description)
        }
        cards.forEach {
            collection.addCard($0)
        }

        collection.shuffle()
        XCTAssert(collection.count == 20)

        let allMatch = cards.indices.allSatisfy({
            cards[$0] === collection.getCardByIndex($0)
        })
        XCTAssert(!allMatch)
    }

    func test_removeCard() {
        let collection = CardCollection()

        let card1 = Card(name: "card 1")
        let card2 = Card(name: "card 2")

        collection.addCard(card1)
        collection.addCard(card2)

        collection.removeCard(card1)
        XCTAssert(collection.count == 1)
        XCTAssert(!collection.containsCard(card1))

        collection.removeCard(card2)
        XCTAssert(collection.isEmpty)
    }

    func test_removeCard_empty() {
        let collection = CardCollection()

        let card1 = Card(name: "card 1")

        collection.removeCard(card1)
        XCTAssert(collection.isEmpty)
    }

    func test_removeCard_nonExistant() {
        let collection = CardCollection()

        let card1 = Card(name: "card 1")
        collection.addCard(card1)

        let card2 = Card(name: "card 2")
        collection.removeCard(card2)
        XCTAssert(collection.count == 1)
        XCTAssert(collection.containsCard(card1))
    }
}
