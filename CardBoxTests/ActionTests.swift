//
//  ActionTests.swift
//  CardBoxTests
//
//  Created by Bryann Yeap Kok Keong on 20/3/22.
//

import XCTest
@testable import CardBox

class ActionTests: XCTestCase {

    var gameRunner: GameRunner!

    var singleTargetCard: Card!
    var allTargetCard: Card!
    var noTargetCard: Card!

    let cardTypeKey = "CARD_TYPE"

    let initialNumOfCardsInDeck = 6
    let numOfPlayers = 2

    lazy var cardCombo: CardCombo = { cards in
        guard cards.count == 2 else {
            return []
        }

        guard cards[0].getAdditionalParams(key: self.cardTypeKey) ==
                cards[1].getAdditionalParams(key: self.cardTypeKey) else {
                    return []
                }

        return [PlayerOutOfGameCardAction()]
    }

    override func setUpWithError() throws {
        try super.setUpWithError()
        gameRunner = getAndSetupGameRunnerInstance()
        singleTargetCard = generateSingleTargetCard()
        allTargetCard = generateAllTargetCard()
        noTargetCard = generateNoTargetCard()
    }
}

extension ActionTests {

    func test_addCardToDeckAction_addSingleCard() {
        XCTAssertEqual(gameRunner.deck.count, initialNumOfCardsInDeck)

        ActionDispatcher.runAction(AddCardToDeckAction(card: allTargetCard),
                                   on: gameRunner)
        XCTAssertEqual(gameRunner.deck.count, initialNumOfCardsInDeck + 1)
        XCTAssertEqual(gameRunner.deck.bottomCard?.getAdditionalParams(key: cardTypeKey),
                       allTargetCard.getAdditionalParams(key: cardTypeKey))
    }

    func test_addCardToDeckAction_addMultipleCards() {
        XCTAssertEqual(gameRunner.deck.count, initialNumOfCardsInDeck)

        for _ in 0 ..< 15 {
            ActionDispatcher.runAction(AddCardToDeckAction(card: singleTargetCard),
                                       on: gameRunner)
            ActionDispatcher.runAction(AddCardToDeckAction(card: allTargetCard),
                                       on: gameRunner)
            ActionDispatcher.runAction(AddCardToDeckAction(card: noTargetCard),
                                       on: gameRunner)
        }

        XCTAssertEqual(gameRunner.deck.count, initialNumOfCardsInDeck + 3 * 15)
        XCTAssertEqual(gameRunner.deck.bottomCard?.getAdditionalParams(key: cardTypeKey),
                       noTargetCard.getAdditionalParams(key: cardTypeKey))
    }

    func test_addCardToPlayerAction_addSingleCard() throws {
        let currentPlayer = try XCTUnwrap(gameRunner.players.currentPlayer)
        XCTAssertEqual(currentPlayer.getHand().count, 0)

        ActionDispatcher.runAction(AddCardToPlayerAction(player: currentPlayer,
                                                         card: singleTargetCard),
                                   on: gameRunner)
        XCTAssertEqual(currentPlayer.getHand().count, 1)
        XCTAssertEqual(currentPlayer.getHand().bottomCard?.getAdditionalParams(key: cardTypeKey),
                       singleTargetCard.getAdditionalParams(key: cardTypeKey))
    }

    func test_addCardToPlayerAction_addMultipleCards() throws {
        let currentPlayer = try XCTUnwrap(gameRunner.players.currentPlayer)
        XCTAssertEqual(currentPlayer.getHand().count, 0)

        for _ in 0 ..< 20 {
            ActionDispatcher.runAction(AddCardToPlayerAction(player: currentPlayer,
                                                             card: singleTargetCard),
                                       on: gameRunner)
            ActionDispatcher.runAction(AddCardToPlayerAction(player: currentPlayer,
                                                             card: allTargetCard),
                                       on: gameRunner)
            ActionDispatcher.runAction(AddCardToPlayerAction(player: currentPlayer,
                                                             card: noTargetCard),
                                       on: gameRunner)
        }

        XCTAssertEqual(currentPlayer.getHand().count, 3 * 20)
        XCTAssertEqual(currentPlayer.getHand().bottomCard?.getAdditionalParams(key: cardTypeKey),
                       noTargetCard.getAdditionalParams(key: cardTypeKey))
    }

    func test_conditionalAction_whenTrueHasNoFalseAction() throws {
        let currentPlayer = try XCTUnwrap(gameRunner.players.currentPlayer)
        XCTAssertEqual(currentPlayer.getHand().count, 0)

        let condition: (GameRunnerReadOnly) -> Bool  = { _ in true }
        let isTrueActions: [Action] = [AddCardToPlayerAction(
            player: currentPlayer,
            card: allTargetCard)
        ]
        let isFalseActions: [Action]? = nil

        let conditionalAction = ConditionalAction(
            condition: condition,
            isTrueActions: isTrueActions,
            isFalseActions: isFalseActions
        )

        ActionDispatcher.runAction(conditionalAction,
                                   on: gameRunner)
        XCTAssertEqual(currentPlayer.getHand().count, 1)
        XCTAssertEqual(currentPlayer.getHand().bottomCard?.getAdditionalParams(key: cardTypeKey),
                       allTargetCard.getAdditionalParams(key: cardTypeKey))
    }

    func test_conditionalAction_whenTrueHasFalseAction() throws {
        let currentPlayer = try XCTUnwrap(gameRunner.players.currentPlayer)
        gameRunner.advanceToNextPlayer()
        let nextPlayer = try XCTUnwrap(gameRunner.players.currentPlayer)
        gameRunner.advanceToNextPlayer()

        XCTAssertEqual(currentPlayer.getHand().count, 0)
        XCTAssertEqual(nextPlayer.getHand().count, 0)

        let condition: (GameRunnerReadOnly) -> Bool  = { _ in true }
        let isTrueActions: [Action] = [AddCardToPlayerAction(
            player: currentPlayer,
            card: singleTargetCard)
        ]
        let isFalseActions: [Action]? = [AddCardToPlayerAction(
            player: nextPlayer,
            card: allTargetCard)
        ]

        let conditionalAction = ConditionalAction(
            condition: condition,
            isTrueActions: isTrueActions,
            isFalseActions: isFalseActions
        )

        ActionDispatcher.runAction(conditionalAction,
                                   on: gameRunner)
        XCTAssertEqual(currentPlayer.getHand().count, 1)
        XCTAssertEqual(currentPlayer.getHand().bottomCard?.getAdditionalParams(key: cardTypeKey),
                       singleTargetCard.getAdditionalParams(key: cardTypeKey))
        XCTAssertEqual(nextPlayer.getHand().count, 0)
    }

    func test_conditionalAction_whenFalse() throws {
        let currentPlayer = try XCTUnwrap(gameRunner.players.currentPlayer)
        gameRunner.advanceToNextPlayer()
        let nextPlayer = try XCTUnwrap(gameRunner.players.currentPlayer)
        gameRunner.advanceToNextPlayer()

        XCTAssertEqual(currentPlayer.getHand().count, 0)
        XCTAssertEqual(nextPlayer.getHand().count, 0)

        let condition: (GameRunnerReadOnly) -> Bool  = { _ in false }
        let isTrueActions: [Action] = [AddCardToPlayerAction(
            player: currentPlayer,
            card: singleTargetCard)
        ]
        let isFalseActions: [Action]? = [AddCardToPlayerAction(
            player: nextPlayer,
            card: allTargetCard)
        ]

        let conditionalAction = ConditionalAction(
            condition: condition,
            isTrueActions: isTrueActions,
            isFalseActions: isFalseActions
        )

        ActionDispatcher.runAction(conditionalAction,
                                   on: gameRunner)
        XCTAssertEqual(currentPlayer.getHand().count, 0)
        XCTAssertEqual(nextPlayer.getHand().count, 1)
        XCTAssertEqual(nextPlayer.getHand().bottomCard?.getAdditionalParams(key: cardTypeKey),
                       allTargetCard.getAdditionalParams(key: cardTypeKey))
    }

    func test_distributeNonNegativeCardsToPlayerAction_allCardsInDeckDistributed() throws {
        let currentPlayer = try XCTUnwrap(gameRunner.players.currentPlayer)
        gameRunner.advanceToNextPlayer()
        let nextPlayer = try XCTUnwrap(gameRunner.players.currentPlayer)
        gameRunner.advanceToNextPlayer()

        XCTAssertEqual(currentPlayer.getHand().count, 0)
        XCTAssertEqual(nextPlayer.getHand().count, 0)
        XCTAssertEqual(gameRunner.deck.count, 6)

        ActionDispatcher.runAction(DistributeCardsToPlayerAction(numCards: 3),
                                   on: gameRunner)

        XCTAssertEqual(currentPlayer.getHand().count, 3)
        XCTAssertEqual(nextPlayer.getHand().count, 3)
        XCTAssertEqual(gameRunner.deck.count, 0)
    }

    func test_distributeNonNegativeositiveCardsToPlayerAction_notAllCardsInDeckDistributed() throws {
        let currentPlayer = try XCTUnwrap(gameRunner.players.currentPlayer)
        gameRunner.advanceToNextPlayer()
        let nextPlayer = try XCTUnwrap(gameRunner.players.currentPlayer)
        gameRunner.advanceToNextPlayer()

        XCTAssertEqual(currentPlayer.getHand().count, 0)
        XCTAssertEqual(nextPlayer.getHand().count, 0)
        XCTAssertEqual(gameRunner.deck.count, 6)

        ActionDispatcher.runAction(DistributeCardsToPlayerAction(numCards: 2),
                                   on: gameRunner)

        XCTAssertEqual(currentPlayer.getHand().count, 2)
        XCTAssertEqual(nextPlayer.getHand().count, 2)
        XCTAssertEqual(gameRunner.deck.count, 2)
    }

    func test_distributeNonNegativeCardsToPlayerAction_noCardsDistributed() throws {
        let currentPlayer = try XCTUnwrap(gameRunner.players.currentPlayer)
        gameRunner.advanceToNextPlayer()
        let nextPlayer = try XCTUnwrap(gameRunner.players.currentPlayer)
        gameRunner.advanceToNextPlayer()

        XCTAssertEqual(currentPlayer.getHand().count, 0)
        XCTAssertEqual(nextPlayer.getHand().count, 0)
        XCTAssertEqual(gameRunner.deck.count, 6)

        ActionDispatcher.runAction(DistributeCardsToPlayerAction(numCards: 0),
                                   on: gameRunner)

        XCTAssertEqual(currentPlayer.getHand().count, 0)
        XCTAssertEqual(nextPlayer.getHand().count, 0)
        XCTAssertEqual(gameRunner.deck.count, 6)
    }

    func test_distributeMoreCardsThanInDeckToPlayerAction_allCardsInDeckDistributed() throws {
        let currentPlayer = try XCTUnwrap(gameRunner.players.currentPlayer)
        gameRunner.advanceToNextPlayer()
        let nextPlayer = try XCTUnwrap(gameRunner.players.currentPlayer)
        gameRunner.advanceToNextPlayer()

        XCTAssertEqual(currentPlayer.getHand().count, 0)
        XCTAssertEqual(nextPlayer.getHand().count, 0)
        XCTAssertEqual(gameRunner.deck.count, 6)

        ActionDispatcher.runAction(DistributeCardsToPlayerAction(numCards: initialNumOfCardsInDeck + 100),
                                   on: gameRunner)

        XCTAssertEqual(currentPlayer.getHand().count, 3)
        XCTAssertEqual(nextPlayer.getHand().count, 3)
        XCTAssertEqual(gameRunner.deck.count, 0)
    }

    func test_distributeNegativeCardsToPlayerAction_noCardsDistributed() throws {
        let currentPlayer = try XCTUnwrap(gameRunner.players.currentPlayer)
        gameRunner.advanceToNextPlayer()
        let nextPlayer = try XCTUnwrap(gameRunner.players.currentPlayer)
        gameRunner.advanceToNextPlayer()

        XCTAssertEqual(currentPlayer.getHand().count, 0)
        XCTAssertEqual(nextPlayer.getHand().count, 0)
        XCTAssertEqual(gameRunner.deck.count, 6)

        ActionDispatcher.runAction(DistributeCardsToPlayerAction(numCards: -1),
                                   on: gameRunner)

        XCTAssertEqual(currentPlayer.getHand().count, 0)
        XCTAssertEqual(nextPlayer.getHand().count, 0)
        XCTAssertEqual(gameRunner.deck.count, 6)
    }

    func test_distributeCardsToPlayerAction_onlyInGamePlayerGetsCards() throws {
        let currentPlayer = try XCTUnwrap(gameRunner.players.currentPlayer)
        gameRunner.advanceToNextPlayer()
        let nextPlayer = try XCTUnwrap(gameRunner.players.currentPlayer)
        gameRunner.advanceToNextPlayer()
        nextPlayer.setOutOfGame(true)

        XCTAssertEqual(currentPlayer.getHand().count, 0)
        XCTAssertEqual(nextPlayer.getHand().count, 0)
        XCTAssertEqual(gameRunner.deck.count, 6)

        ActionDispatcher.runAction(DistributeCardsToPlayerAction(numCards: 3),
                                   on: gameRunner)

        XCTAssertEqual(currentPlayer.getHand().count, 3)
        XCTAssertEqual(nextPlayer.getHand().count, 0)
        XCTAssertEqual(gameRunner.deck.count, 3)
    }

    func test_drawCardFromDeckToCurrentPlayerAction_drawSingleCard() throws {
        let currentPlayer = try XCTUnwrap(gameRunner.players.currentPlayer)
        let initialTopCardOfDeck = try XCTUnwrap(gameRunner.deck.topCard)
        XCTAssertEqual(currentPlayer.getHand().count, 0)
        XCTAssertEqual(gameRunner.deck.count, 6)

        ActionDispatcher.runAction(
            DrawCardFromDeckToCurrentPlayerAction(
                target: .currentPlayer),
            on: gameRunner
        )

        XCTAssertEqual(currentPlayer.getHand().count, 1)
        XCTAssertEqual(currentPlayer.getHand().bottomCard?.getAdditionalParams(key: cardTypeKey),
                       initialTopCardOfDeck.getAdditionalParams(key: cardTypeKey))
        XCTAssertEqual(gameRunner.deck.count, 5)
    }

    func test_drawCardFromDeckToCurrentPlayerAction_drawAllCards() throws {
        let currentPlayer = try XCTUnwrap(gameRunner.players.currentPlayer)
        let initialBottomCardOfDeck = try XCTUnwrap(gameRunner.deck.bottomCard)
        XCTAssertEqual(currentPlayer.getHand().count, 0)
        XCTAssertEqual(gameRunner.deck.count, 6)

        for _ in 0 ..< gameRunner.deck.count {
            ActionDispatcher.runAction(
                DrawCardFromDeckToCurrentPlayerAction(
                    target: .currentPlayer),
                on: gameRunner
            )
        }

        XCTAssertEqual(currentPlayer.getHand().count, 6)
        XCTAssertEqual(currentPlayer.getHand().bottomCard?.getAdditionalParams(key: cardTypeKey),
                       initialBottomCardOfDeck.getAdditionalParams(key: cardTypeKey))
        XCTAssertEqual(gameRunner.deck.count, 0)
    }

    func test_drawCardFromDeckToCurrentPlayerAction_drawMoreCardsThanInDeck() throws {
        let currentPlayer = try XCTUnwrap(gameRunner.players.currentPlayer)
        let initialBottomCardOfDeck = try XCTUnwrap(gameRunner.deck.bottomCard)
        XCTAssertEqual(currentPlayer.getHand().count, 0)
        XCTAssertEqual(gameRunner.deck.count, 6)

        for _ in 0 ..< gameRunner.deck.count + 100 {
            ActionDispatcher.runAction(
                DrawCardFromDeckToCurrentPlayerAction(
                    target: .currentPlayer),
                on: gameRunner
            )
        }

        XCTAssertEqual(currentPlayer.getHand().count, 6)
        XCTAssertEqual(currentPlayer.getHand().bottomCard?.getAdditionalParams(key: cardTypeKey),
                       initialBottomCardOfDeck.getAdditionalParams(key: cardTypeKey))
        XCTAssertEqual(gameRunner.deck.count, 0)
    }

    func test_endTurnActionTwoPlayersLeft_currentPlayerChanges() throws {
        let initialCurrentPlayer = try XCTUnwrap(gameRunner.players.currentPlayer)
        ActionDispatcher.runAction(EndTurnAction(), on: gameRunner)
        let newCurrentPlayer = try XCTUnwrap(gameRunner.players.currentPlayer)
        let checkEquals: (Player, Player) -> Bool = { player1, player2 in
            player1 === player2
        }
        XCTAssertFalse(checkEquals(initialCurrentPlayer, newCurrentPlayer))
    }

    func test_endTurnActionOnePlayerLeft_currentPlayerDoesNotChange() throws {
        let initialCurrentPlayer = try XCTUnwrap(gameRunner.players.currentPlayer)

        ActionDispatcher.runAction(EndTurnAction(), on: gameRunner)

        let outOfGamePlayer = try XCTUnwrap(gameRunner.players.currentPlayer)
        outOfGamePlayer.setOutOfGame(true)

        ActionDispatcher.runAction(EndTurnAction(), on: gameRunner)
        ActionDispatcher.runAction(EndTurnAction(), on: gameRunner)

        let newCurrentPlayer = try XCTUnwrap(gameRunner.players.currentPlayer)

        let checkEquals: (Player, Player) -> Bool = { player1, player2 in
            player1 === player2
        }

        XCTAssertTrue(checkEquals(initialCurrentPlayer, newCurrentPlayer))
    }
}
