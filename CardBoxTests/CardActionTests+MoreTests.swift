//
//  CardActionTests+MoreTests.swift
//  CardBoxTests
//
//  Created by Bryann Yeap Kok Keong on 20/3/22.
//

import XCTest
@testable import CardBox

extension CardActionTests {

    func test_conditionalCardAction_whenTrueHasNoFalseAction() throws {
        let currentPlayer = try XCTUnwrap(gameRunner.players.currentPlayer)
        let initialOutOfGameStatus = currentPlayer.isOutOfGame

        let condition: (GameRunnerReadOnly, Player, GameplayTarget) -> Bool  = { _, _, _ in true }
        let isTrueActions: [CardAction] = [PlayerOutOfGameCardAction()]
        let isFalseActions: [CardAction]? = nil

        let conditionalCardAction = ConditionalCardAction(
            condition: condition,
            isTrueCardActions: isTrueActions,
            isFalseCardActions: isFalseActions
        )

        let card = Card(name: "Conditional Card", typeOfTargettedCard: .noTargetCard)
        card.addPlayAction(conditionalCardAction)

        ActionDispatcher.runAction(
            PlayCardAction(
                player: currentPlayer,
                cards: [card],
                target: .none
            ),
            on: gameRunner
        )

        let newOutOfGameStatus = currentPlayer.isOutOfGame

        XCTAssertFalse(initialOutOfGameStatus)
        XCTAssertTrue(newOutOfGameStatus)
    }

    func test_conditionalCardAction_whenTrueHasFalseAction() throws {
        let testKey = "TEST_KEY"
        let testValueTrue = "TEST_VALUE_TRUE"
        let testValueFalse = "TEST_VALUE_FALSE"

        let currentPlayer = try XCTUnwrap(gameRunner.players.currentPlayer)

        let condition: (GameRunnerReadOnly, Player, GameplayTarget) -> Bool  = { _, _, _ in true }
        let isTrueActions: [CardAction] = [
            SetPlayerAdditionalParamsCardAction(
                playerResolver: { _ in currentPlayer },
                key: testKey,
                value: testValueTrue
            )
        ]
        let isFalseActions: [CardAction]? = [
            SetPlayerAdditionalParamsCardAction(
                playerResolver: { _ in currentPlayer },
                key: testKey,
                value: testValueFalse
            )
        ]
        let conditionalCardAction = ConditionalCardAction(
            condition: condition,
            isTrueCardActions: isTrueActions,
            isFalseCardActions: isFalseActions
        )

        let card = Card(name: "Conditional Card", typeOfTargettedCard: .noTargetCard)
        card.addPlayAction(conditionalCardAction)

        XCTAssertNotEqual(currentPlayer.getAdditionalParams(key: testKey), testValueTrue)
        XCTAssertNotEqual(currentPlayer.getAdditionalParams(key: testKey), testValueFalse)

        ActionDispatcher.runAction(
            PlayCardAction(
                player: currentPlayer,
                cards: [card],
                target: .none
            ),
            on: gameRunner
        )

        XCTAssertEqual(currentPlayer.getAdditionalParams(key: testKey), testValueTrue)
        XCTAssertNotEqual(currentPlayer.getAdditionalParams(key: testKey), testValueFalse)
    }

    func test_conditionalCardAction_whenFalse() throws {
        let testKey = "TEST_KEY"
        let testValueTrue = "TEST_VALUE_TRUE"
        let testValueFalse = "TEST_VALUE_FALSE"

        let currentPlayer = try XCTUnwrap(gameRunner.players.currentPlayer)

        let condition: (GameRunnerReadOnly, Player, GameplayTarget) -> Bool  = { _, _, _ in false }
        let isTrueActions: [CardAction] = [
            SetPlayerAdditionalParamsCardAction(
                playerResolver: { _ in currentPlayer },
                key: testKey,
                value: testValueTrue
            )
        ]
        let isFalseActions: [CardAction]? = [
            SetPlayerAdditionalParamsCardAction(
                playerResolver: { _ in currentPlayer },
                key: testKey,
                value: testValueFalse
            )
        ]
        let conditionalCardAction = ConditionalCardAction(
            condition: condition,
            isTrueCardActions: isTrueActions,
            isFalseCardActions: isFalseActions
        )

        let card = Card(name: "Conditional Card", typeOfTargettedCard: .noTargetCard)
        card.addPlayAction(conditionalCardAction)

        XCTAssertNotEqual(currentPlayer.getAdditionalParams(key: testKey), testValueTrue)
        XCTAssertNotEqual(currentPlayer.getAdditionalParams(key: testKey), testValueFalse)

        ActionDispatcher.runAction(
            PlayCardAction(
                player: currentPlayer,
                cards: [card],
                target: .none
            ),
            on: gameRunner
        )

        XCTAssertNotEqual(currentPlayer.getAdditionalParams(key: testKey), testValueTrue)
        XCTAssertEqual(currentPlayer.getAdditionalParams(key: testKey), testValueFalse)
    }

    func test_playerTakesNthCardFromPlayerCardAction_targetPlayerHasAtLeastNCards() throws {
        let n = 0
        let currentPlayer = try XCTUnwrap(gameRunner.players.currentPlayer)
        gameRunner.advanceToNextPlayer()
        let nextPlayer = try XCTUnwrap(gameRunner.players.currentPlayer)
        gameRunner.advanceToNextPlayer()
        nextPlayer.addCard(singleTargetCard)

        XCTAssertFalse(currentPlayer.hasCard(singleTargetCard))
        XCTAssertTrue(nextPlayer.hasCard(singleTargetCard))

        let takeNthCard = Card(name: "Take Nth", typeOfTargettedCard: .targetSinglePlayerCard)
        takeNthCard.addPlayAction(PlayerTakesNthCardFromPlayerCardAction(n: n, stateOfN: .given))

        ActionDispatcher.runAction(
            PlayCardAction(
                player: currentPlayer,
                cards: [takeNthCard],
                target: .single(nextPlayer)),
            on: gameRunner
        )

        XCTAssertTrue(currentPlayer.hasCard(singleTargetCard))
        XCTAssertFalse(nextPlayer.hasCard(singleTargetCard))
    }

    func test_playerTakesNthCardFromPlayerCardAction_targetPlayerHasLessThanNCards() throws {
        let n = 1
        let currentPlayer = try XCTUnwrap(gameRunner.players.currentPlayer)
        let initialCurrentPlayerHand = CardCollection(cards: currentPlayer.getHand().getCards())
        gameRunner.advanceToNextPlayer()
        let nextPlayer = try XCTUnwrap(gameRunner.players.currentPlayer)
        nextPlayer.addCard(noTargetCard)
        let initialNextPlayerHand = CardCollection(cards: nextPlayer.getHand().getCards())
        gameRunner.advanceToNextPlayer()

        let takeNthCard = Card(name: "Take Nth", typeOfTargettedCard: .targetSinglePlayerCard)
        takeNthCard.addPlayAction(PlayerTakesNthCardFromPlayerCardAction(n: n, stateOfN: .given))

        ActionDispatcher.runAction(
            PlayCardAction(
                player: currentPlayer,
                cards: [takeNthCard],
                target: .single(nextPlayer)),
            on: gameRunner
        )

        XCTAssertTrue(CardBoxTestsUtil.areCardCollectionsSame(firstCardCollection: initialCurrentPlayerHand,
                                                              secondCardCollection: currentPlayer.getHand(),
                                                              gameRunner: gameRunner))
        XCTAssertTrue(CardBoxTestsUtil.areCardCollectionsSame(firstCardCollection: initialNextPlayerHand,
                                                              secondCardCollection: nextPlayer.getHand(),
                                                              gameRunner: gameRunner))
    }

    func test_playerTakesNthCardFromPlayerCardAction_targetPlayerOutOfGame() throws {
        let n = 0
        let currentPlayer = try XCTUnwrap(gameRunner.players.currentPlayer)
        let initialCurrentPlayerHand = CardCollection(cards: currentPlayer.getHand().getCards())
        gameRunner.advanceToNextPlayer()
        let nextPlayer = try XCTUnwrap(gameRunner.players.currentPlayer)
        nextPlayer.addCard(singleTargetCard)
        let initialNextPlayerHand = CardCollection(cards: nextPlayer.getHand().getCards())
        gameRunner.advanceToNextPlayer()
        nextPlayer.setOutOfGame(true)

        let takeNthCard = Card(name: "Take Nth", typeOfTargettedCard: .targetSinglePlayerCard)
        takeNthCard.addPlayAction(PlayerTakesNthCardFromPlayerCardAction(n: n, stateOfN: .given))

        ActionDispatcher.runAction(
            PlayCardAction(
                player: currentPlayer,
                cards: [takeNthCard],
                target: .single(nextPlayer)),
            on: gameRunner
        )

        XCTAssertTrue(CardBoxTestsUtil.areCardCollectionsSame(firstCardCollection: initialCurrentPlayerHand,
                                                              secondCardCollection: currentPlayer.getHand(),
                                                              gameRunner: gameRunner))
        XCTAssertTrue(CardBoxTestsUtil.areCardCollectionsSame(firstCardCollection: initialNextPlayerHand,
                                                              secondCardCollection: nextPlayer.getHand(),
                                                              gameRunner: gameRunner))
    }

    func test_playerTakesNthCardFromPlayerCardAction_randomN() throws {
        let currentPlayer = try XCTUnwrap(gameRunner.players.currentPlayer)
        gameRunner.advanceToNextPlayer()
        let nextPlayer = try XCTUnwrap(gameRunner.players.currentPlayer)
        gameRunner.advanceToNextPlayer()
        nextPlayer.addCard(singleTargetCard)

        XCTAssertFalse(currentPlayer.hasCard(singleTargetCard))
        XCTAssertTrue(nextPlayer.hasCard(singleTargetCard))

        let takeNthCard = Card(name: "Take Nth", typeOfTargettedCard: .targetSinglePlayerCard)
        takeNthCard.addPlayAction(PlayerTakesNthCardFromPlayerCardAction(n: -1, stateOfN: .random))

        ActionDispatcher.runAction(
            PlayCardAction(
                player: currentPlayer,
                cards: [takeNthCard],
                target: .single(nextPlayer)),
            on: gameRunner
        )

        XCTAssertTrue(currentPlayer.hasCard(singleTargetCard))
        XCTAssertFalse(nextPlayer.hasCard(singleTargetCard))
    }

    func test_playerTakesChosenCardFromGameplayAction_gameplayHasCard() throws {
        let cardToChoose: Card = noTargetCard
        let cardToChoosePredicate: (Card) -> Bool = { card in
            card.getAdditionalParams(key: self.cardTypeKey) == cardToChoose.getAdditionalParams(key: self.cardTypeKey)
        }
        let currentPlayer = try XCTUnwrap(gameRunner.players.currentPlayer)
        let gameplayArea = gameRunner.gameplayArea
        gameplayArea.addCard(cardToChoose)

        XCTAssertFalse(currentPlayer.hasCard(where: cardToChoosePredicate))
        XCTAssertTrue(gameplayArea.containsCard(where: cardToChoosePredicate))

        let chooseCard = Card(name: "Choose", typeOfTargettedCard: .targetSinglePlayerCard)
        chooseCard.addPlayAction(
            PlayerTakesChosenCardFromGameplayCardAction(cardPredicate: cardToChoosePredicate)
        )

        ActionDispatcher.runAction(
            PlayCardAction(
                player: currentPlayer,
                cards: [chooseCard],
                target: .none),
            on: gameRunner
        )

        XCTAssertTrue(currentPlayer.hasCard(where: cardToChoosePredicate))
        XCTAssertFalse(gameplayArea.containsCard(where: cardToChoosePredicate))
    }

    func test_playerTakesChosenCardFromGameplayCardAction_gameplayDoesNotHaveCard() throws {
        let cardToChoose: Card = noTargetCard
        let cardToChoosePredicate: (Card) -> Bool = { card in
            card.getAdditionalParams(key: self.cardTypeKey) == cardToChoose.getAdditionalParams(key: self.cardTypeKey)
        }
        let currentPlayer = try XCTUnwrap(gameRunner.players.currentPlayer)
        let gameplayArea = gameRunner.gameplayArea

        XCTAssertFalse(currentPlayer.hasCard(where: cardToChoosePredicate))
        XCTAssertFalse(gameplayArea.containsCard(where: cardToChoosePredicate))

        let chooseCard = Card(name: "Choose", typeOfTargettedCard: .targetSinglePlayerCard)
        chooseCard.addPlayAction(
            PlayerTakesChosenCardFromGameplayCardAction(cardPredicate: cardToChoosePredicate)
        )

        ActionDispatcher.runAction(
            PlayCardAction(
                player: currentPlayer,
                cards: [chooseCard],
                target: .none),
            on: gameRunner
        )

        XCTAssertFalse(currentPlayer.hasCard(where: cardToChoosePredicate))
        XCTAssertFalse(gameplayArea.containsCard(where: cardToChoosePredicate))
    }
}
