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

    // CHANCE OF FALSE NEGATIVE:
    // (1 / (6!/2!2!2!)) = (1 / 90)
    func test_shuffleDeckAction_deckOrderChanges() {
        let initialDeck = CardCollection(cards: gameRunner.deck.getCards())
        ActionDispatcher.runAction(ShuffleDeckAction(), on: gameRunner)
        let newDeck = gameRunner.deck
        XCTAssertFalse(CardBoxTestsUtil.areCardCollectionsSame(firstCardCollection: initialDeck,
                                                               secondCardCollection: newDeck,
                                                               gameRunner: gameRunner))
    }

    func test_playCardAction_leaveGameCard() throws {
        let currentPlayer = try XCTUnwrap(gameRunner.players.currentPlayer)

        let leaveGameCard = Card(name: "Leave Game", typeOfTargettedCard: .noTargetCard)
        leaveGameCard.setAdditionalParams(key: cardTypeKey, value: "leave game")
        leaveGameCard.addPlayAction(PlayerOutOfGameCardAction())

        let initialGameplay = CardCollection(cards: gameRunner.gameplayArea.getCards())
        ActionDispatcher.runAction(PlayCardAction(player: currentPlayer,
                                                  cards: [leaveGameCard],
                                                  target: .none),
                                   on: gameRunner)
        let newGameplay = gameRunner.gameplayArea

        XCTAssertTrue(currentPlayer.isOutOfGame)
        XCTAssertEqual(newGameplay.count, initialGameplay.count + 1)
        XCTAssertNotEqual(initialGameplay.topCard?.getAdditionalParams(key: cardTypeKey),
                          newGameplay.topCard?.getAdditionalParams(key: cardTypeKey))
    }

    func test_playCardComboAction_cardComboAddsCardToDeck() throws {
        let currentPlayer = try XCTUnwrap(gameRunner.players.currentPlayer)

        let comboCard1 = generateAllTargetCard()
        let comboCard2 = generateAllTargetCard()
        let comboCards = [comboCard1, comboCard2]
        currentPlayer.addCard(comboCard1)
        currentPlayer.addCard(comboCard2)
        let comboActions = cardCombo(comboCards)

        let initialGameplay = CardCollection(cards: gameRunner.gameplayArea.getCards())
        ActionDispatcher.runAction(PlayCardComboAction(player: currentPlayer,
                                                       cards: comboCards,
                                                       target: .none,
                                                       comboActions: comboActions),
                                   on: gameRunner)
        let newGameplay = gameRunner.gameplayArea

        XCTAssertTrue(currentPlayer.isOutOfGame)
        XCTAssertEqual(newGameplay.count, initialGameplay.count + 2)
        XCTAssertNotEqual(initialGameplay.topCard?.getAdditionalParams(key: cardTypeKey),
                          newGameplay.topCard?.getAdditionalParams(key: cardTypeKey))
    }
}
