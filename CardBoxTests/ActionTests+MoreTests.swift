//
//  ActionTests+MoreTests.swift
//  CardBoxTests
//
//  Created by Bryann Yeap Kok Keong on 20/3/22.
//

import XCTest
@testable import CardBox

extension ActionTests {

    func test_displayMessageAction_noError() {
        ActionDispatcher.runAction(DisplayMessageAction(message: "DISPLAY MESSAGE"),
                                   on: gameRunner)
    }

    func test_displayCardsAction_noError() {
        ActionDispatcher.runAction(DisplayCardsAction(cards: [singleTargetCard]),
                                   on: gameRunner)
    }

    // CHANCE OF FAILING:
    // (1 / (6!/2!2!2!)) = (1 / 90)
    func test_shuffleDeckAction_deckOrderChanges() {
        let initialDeck = CardCollection(cards: gameRunner.deck.getCards())
        ActionDispatcher.runAction(ShuffleDeckAction(), on: gameRunner)
        let newDeck = gameRunner.deck
        XCTAssertFalse(areDeckSame(firstDeck: initialDeck, secondDeck: newDeck))
    }

    private func areDeckSame(firstDeck: CardCollection, secondDeck: CardCollection) -> Bool {
        var orderIsSame = true

        for index in 0 ..< gameRunner.deck.count {
            let firstDeckCard = firstDeck.getCardByIndex(index)
            let secondDeckCard = secondDeck.getCardByIndex(index)
            orderIsSame = orderIsSame && firstDeckCard?.getAdditionalParams(key: cardTypeKey) ==
            secondDeckCard?.getAdditionalParams(key: cardTypeKey)
        }

        return orderIsSame
    }

    func test_playCardAction_shuffleCard() throws {
        let currentPlayer = try XCTUnwrap(gameRunner.players.currentPlayer)

        let shuffleCard = Card(name: "Shuffle", typeOfTargettedCard: .noTargetCard)
        shuffleCard.setAdditionalParams(key: cardTypeKey, value: "shuffle")
        shuffleCard.addPlayAction(ShuffleDeckCardAction())

        let initialDeck = CardCollection(cards: gameRunner.deck.getCards())
        let initialGameplay = CardCollection(cards: gameRunner.gameplayArea.getCards())

        ActionDispatcher.runAction(PlayCardAction(player: currentPlayer,
                                                  cards: [shuffleCard],
                                                  target: .none),
                                   on: gameRunner)

        let newDeck = gameRunner.deck
        let newGameplay = gameRunner.gameplayArea

        XCTAssertFalse(areDeckSame(firstDeck: initialDeck, secondDeck: newDeck))
        XCTAssertEqual(newGameplay.count, initialGameplay.count + 1)
        XCTAssertNotEqual(initialGameplay.topCard?.getAdditionalParams(key: cardTypeKey),
                          newGameplay.topCard?.getAdditionalParams(key: cardTypeKey))
    }

    func test_playCardComboAction_cardComboShufflesDeck() throws {
        let currentPlayer = try XCTUnwrap(gameRunner.players.currentPlayer)

        let comboCard1 = generateAllTargetCard()
        let comboCard2 = generateAllTargetCard()
        let comboCards = [comboCard1, comboCard2]
        currentPlayer.addCard(comboCard1)
        currentPlayer.addCard(comboCard2)
        let comboActions = cardCombo(comboCards)

        let initialDeck = CardCollection(cards: gameRunner.deck.getCards())
        let initialGameplay = CardCollection(cards: gameRunner.gameplayArea.getCards())

        ActionDispatcher.runAction(PlayCardComboAction(player: currentPlayer,
                                                       cards: comboCards,
                                                       target: .none,
                                                       comboActions: comboActions),
                                   on: gameRunner)

        let newDeck = gameRunner.deck
        let newGameplay = gameRunner.gameplayArea

        XCTAssertFalse(areDeckSame(firstDeck: initialDeck, secondDeck: newDeck))
        XCTAssertEqual(newGameplay.count, initialGameplay.count + 2)
        XCTAssertNotEqual(initialGameplay.topCard?.getAdditionalParams(key: cardTypeKey),
                          newGameplay.topCard?.getAdditionalParams(key: cardTypeKey))
    }
}
