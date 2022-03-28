//
//  CardActionTests.swift
//  CardBoxTests
//
//  Created by Bryann Yeap Kok Keong on 20/3/22.
//

import XCTest
@testable import CardBox

class CardActionTests: XCTestCase {

    var gameRunner: GameRunner!

    var singleTargetCard: Card!
    var allTargetCard: Card!
    var noTargetCard: Card!
    var initialNumOfCardsInDeck: Int!

    let cardTypeKey = CardBoxTestsUtil.cardTypeKey
    let numOfPlayers = 2

    override func setUpWithError() throws {
        try super.setUpWithError()
        gameRunner = getAndSetupGameRunnerInstance()
        singleTargetCard = generateSingleTargetCard()
        allTargetCard = generateAllTargetCard()
        noTargetCard = generateNoTargetCard()
        initialNumOfCardsInDeck = gameRunner.deck.count
    }
}

extension CardActionTests {

    func test_PlayerOutOfGameCardAction_initiallyNotOutOfGamePlayer() throws {
        let currentPlayer = try XCTUnwrap(gameRunner.players.currentPlayer)
        let initialOutOfGameStatus = currentPlayer.isOutOfGame

        let card = Card(name: "Out Of Game", typeOfTargettedCard: .noTargetCard)
        card.addPlayAction(PlayerOutOfGameCardAction())

        ActionDispatcher.runAction(
            PlayCardAction(
                player: currentPlayer,
                cards: [card],
                target: .none),
            on: gameRunner
        )
        let currentOutOfGameStatus = currentPlayer.isOutOfGame

        XCTAssertFalse(initialOutOfGameStatus)
        XCTAssertTrue(currentOutOfGameStatus)
    }

    func test_displayTopNCardsFromDeckCardAction_noError() throws {
        let currentPlayer = try XCTUnwrap(gameRunner.players.currentPlayer)
        let card = Card(name: "Display 5 Top Cards Of Deck", typeOfTargettedCard: .noTargetCard)
        card.addPlayAction(DisplayTopNCardsFromDeckCardAction(n: 5))
        ActionDispatcher.runAction(
            PlayCardAction(
                player: currentPlayer,
                cards: [card],
                target: .none),
            on: gameRunner
        )
    }

    func test_skipTurnCardAction_twoPlayersNotOutOfGame() throws {
        let initialCurrentPlayer = try XCTUnwrap(gameRunner.players.currentPlayer)
        let card = Card(name: "Skip", typeOfTargettedCard: .noTargetCard)
        card.addPlayAction(SkipTurnCardAction())

        ActionDispatcher.runAction(
            PlayCardAction(
                player: initialCurrentPlayer,
                cards: [card],
                target: .none),
            on: gameRunner
        )

        let newCurrentPlayer = try XCTUnwrap(gameRunner.players.currentPlayer)
        let isSamePlayers: (Player, Player) -> Bool = { firstPlayer, secondPlayer in
            firstPlayer === secondPlayer
        }

        XCTAssertFalse(isSamePlayers(initialCurrentPlayer, newCurrentPlayer))
    }

    func test_skipTurnCardAction_onePlayerNotOutOfGame() throws {
        let initialCurrentPlayer = try XCTUnwrap(gameRunner.players.currentPlayer)
        gameRunner.advanceToNextPlayer()
        let initialNextPlayer = try XCTUnwrap(gameRunner.players.currentPlayer)
        gameRunner.advanceToNextPlayer()
        initialNextPlayer.setOutOfGame(true)

        let card = Card(name: "Skip", typeOfTargettedCard: .noTargetCard)
        card.addPlayAction(SkipTurnCardAction())

        ActionDispatcher.runAction(
            PlayCardAction(
                player: initialCurrentPlayer,
                cards: [card],
                target: .none),
            on: gameRunner
        )

        let newCurrentPlayer = try XCTUnwrap(gameRunner.players.currentPlayer)
        let isSamePlayers: (Player, Player) -> Bool = { firstPlayer, secondPlayer in
            firstPlayer === secondPlayer
        }

        XCTAssertTrue(isSamePlayers(initialCurrentPlayer, newCurrentPlayer))
    }

    func test_playerTakesChosenCardFromPlayerCardAction_targetPlayerHasCard() throws {
        let cardToChoose: Card = singleTargetCard
        let cardToChoosePredicate: (Card) -> Bool = { card in
            card.getAdditionalParams(key: self.cardTypeKey) == cardToChoose.getAdditionalParams(key: self.cardTypeKey)
        }

        let currentPlayer = try XCTUnwrap(gameRunner.players.currentPlayer)
        gameRunner.advanceToNextPlayer()
        let nextPlayer = try XCTUnwrap(gameRunner.players.currentPlayer)
        gameRunner.advanceToNextPlayer()
        nextPlayer.addCard(cardToChoose)

        XCTAssertFalse(currentPlayer.hasCard(where: cardToChoosePredicate))
        XCTAssertTrue(nextPlayer.hasCard(where: cardToChoosePredicate))

        let chooseCard = Card(name: "Choose", typeOfTargettedCard: .targetSinglePlayerCard)
        chooseCard.addPlayAction(PlayerTakenChosenCardFromPlayerCardAction(cardPredicate: cardToChoosePredicate))

        ActionDispatcher.runAction(
            PlayCardAction(
                player: currentPlayer,
                cards: [chooseCard],
                target: .single(nextPlayer)),
            on: gameRunner
        )

        XCTAssertTrue(currentPlayer.hasCard(where: cardToChoosePredicate))
        XCTAssertFalse(nextPlayer.hasCard(where: cardToChoosePredicate))
    }

    func test_playerTakesChosenCardFromPlayerCardAction_targetPlayerDoesNotHaveCard() throws {
        let cardToChoose: Card = singleTargetCard
        let cardToChoosePredicate: (Card) -> Bool = { card in
            card.getAdditionalParams(key: self.cardTypeKey) == cardToChoose.getAdditionalParams(key: self.cardTypeKey)
        }

        let currentPlayer = try XCTUnwrap(gameRunner.players.currentPlayer)
        gameRunner.advanceToNextPlayer()
        let nextPlayer = try XCTUnwrap(gameRunner.players.currentPlayer)
        gameRunner.advanceToNextPlayer()

        XCTAssertFalse(currentPlayer.hasCard(where: cardToChoosePredicate))
        XCTAssertFalse(nextPlayer.hasCard(where: cardToChoosePredicate))

        let chooseCard = Card(name: "Choose", typeOfTargettedCard: .targetSinglePlayerCard)
        chooseCard.addPlayAction(PlayerTakenChosenCardFromPlayerCardAction(cardPredicate: cardToChoosePredicate))

        ActionDispatcher.runAction(
            PlayCardAction(
                player: currentPlayer,
                cards: [chooseCard],
                target: .single(nextPlayer)),
            on: gameRunner
        )

        XCTAssertFalse(currentPlayer.hasCard(where: cardToChoosePredicate))
        XCTAssertFalse(nextPlayer.hasCard(where: cardToChoosePredicate))
    }

    func test_playerTakesChosenCardFromPlayerCardAction_targetPlayerOutOfGame() throws {
        let cardToChoose: Card = singleTargetCard
        let cardToChoosePredicate: (Card) -> Bool = { card in
            card.getAdditionalParams(key: self.cardTypeKey) == cardToChoose.getAdditionalParams(key: self.cardTypeKey)
        }

        let currentPlayer = try XCTUnwrap(gameRunner.players.currentPlayer)
        gameRunner.advanceToNextPlayer()
        let nextPlayer = try XCTUnwrap(gameRunner.players.currentPlayer)
        gameRunner.advanceToNextPlayer()
        nextPlayer.addCard(cardToChoose)
        nextPlayer.setOutOfGame(true)

        XCTAssertFalse(currentPlayer.hasCard(where: cardToChoosePredicate))
        XCTAssertFalse(nextPlayer.hasCard(where: cardToChoosePredicate))

        let chooseCard = Card(name: "Choose", typeOfTargettedCard: .targetSinglePlayerCard)
        chooseCard.addPlayAction(PlayerTakenChosenCardFromPlayerCardAction(cardPredicate: cardToChoosePredicate))

        ActionDispatcher.runAction(
            PlayCardAction(
                player: currentPlayer,
                cards: [chooseCard],
                target: .single(nextPlayer)),
            on: gameRunner
        )

        XCTAssertFalse(currentPlayer.hasCard(where: cardToChoosePredicate))
        XCTAssertFalse(nextPlayer.hasCard(where: cardToChoosePredicate))
    }

    func test_playerDiscardCardAction_playerHasCard() throws {
        let currentPlayer = try XCTUnwrap(gameRunner.players.currentPlayer)
        let cardToDiscard: Card = allTargetCard
        currentPlayer.addCard(cardToDiscard)
        let initialCurrentPlayerHand = CardCollection(cards: currentPlayer.getHand().getCards())
        let cardToDiscardCondition: (Card) -> Bool = { [self] card in
            card.getAdditionalParams(key: cardTypeKey) == cardToDiscard.getAdditionalParams(key: cardTypeKey)
        }
        let card = Card(name: "Discard", typeOfTargettedCard: .noTargetCard)
        card.addPlayAction(PlayerDiscardCardAction(where: cardToDiscardCondition))

        ActionDispatcher.runAction(
            PlayCardAction(
                player: currentPlayer,
                cards: [card],
                target: .none),
            on: gameRunner
        )

        let newCurrentPlayerHand = currentPlayer.getHand()

        XCTAssertEqual(newCurrentPlayerHand.count, initialCurrentPlayerHand.count - 1)
        XCTAssertFalse(CardBoxTestsUtil.areCardCollectionsSame(firstCardCollection: initialCurrentPlayerHand,
                                                               secondCardCollection: newCurrentPlayerHand,
                                                               gameRunner: gameRunner))
    }

    func test_playerDiscardCardAction_playerDoesNotHaveCard() throws {
        let currentPlayer = try XCTUnwrap(gameRunner.players.currentPlayer)
        let cardToDiscard: Card = allTargetCard
        let initialCurrentPlayerHand = CardCollection(cards: currentPlayer.getHand().getCards())
        let cardToDiscardCondition: (Card) -> Bool = { [self] card in
            card.getAdditionalParams(key: cardTypeKey) == cardToDiscard.getAdditionalParams(key: cardTypeKey)
        }
        let card = Card(name: "Discard", typeOfTargettedCard: .noTargetCard)
        card.addPlayAction(PlayerDiscardCardAction(where: cardToDiscardCondition))

        ActionDispatcher.runAction(
            PlayCardAction(
                player: currentPlayer,
                cards: [card],
                target: .none),
            on: gameRunner
        )

        let newCurrentPlayerHand = currentPlayer.getHand()

        XCTAssertEqual(newCurrentPlayerHand.count, initialCurrentPlayerHand.count)
        XCTAssertTrue(CardBoxTestsUtil.areCardCollectionsSame(firstCardCollection: initialCurrentPlayerHand,
                                                              secondCardCollection: newCurrentPlayerHand,
                                                              gameRunner: gameRunner))
    }

    func test_playerInsertCardIntoDeckCard_playerHasCard() throws {
        let currentPlayer = try XCTUnwrap(gameRunner.players.currentPlayer)
        let n = 3
        let initialNthCardInDeck = gameRunner.deck.getCardByIndex(n)

        let card = Card(name: "Insert Card Into Deck", typeOfTargettedCard: .noTargetCard)
        card.addPlayAction(PlayerInsertCardIntoDeckCardAction(offsetFromTop: 3))
        currentPlayer.addCard(card)

        ActionDispatcher.runAction(
            PlayCardAction(
                player: currentPlayer,
                cards: [card],
                target: .none),
            on: gameRunner
        )

        let newNthCardInDeck = gameRunner.deck.getCardByIndex(n)

        XCTAssertEqual(gameRunner.deck.count, initialNumOfCardsInDeck + 1)
        XCTAssertNotEqual(initialNthCardInDeck?.getAdditionalParams(key: cardTypeKey),
                          newNthCardInDeck?.getAdditionalParams(key: cardTypeKey))
        XCTAssertEqual(newNthCardInDeck?.getAdditionalParams(key: cardTypeKey),
                       card.getAdditionalParams(key: cardTypeKey))
    }

    func test_playerInsertCardIntoDeckCard_playerDoesNotHaveCard() throws {
        let currentPlayer = try XCTUnwrap(gameRunner.players.currentPlayer)
        let n = 3
        let initialNthCardInDeck = gameRunner.deck.getCardByIndex(n)

        let card = Card(name: "Insert Card Into Deck", typeOfTargettedCard: .noTargetCard)
        card.addPlayAction(PlayerInsertCardIntoDeckCardAction(offsetFromTop: 3))

        ActionDispatcher.runAction(
            PlayCardAction(
                player: currentPlayer,
                cards: [card],
                target: .none),
            on: gameRunner
        )

        let newNthCardInDeck = gameRunner.deck.getCardByIndex(n)

        XCTAssertEqual(gameRunner.deck.count, initialNumOfCardsInDeck)
        XCTAssertEqual(initialNthCardInDeck?.getAdditionalParams(key: cardTypeKey),
                       newNthCardInDeck?.getAdditionalParams(key: cardTypeKey))
        XCTAssertNotEqual(newNthCardInDeck?.getAdditionalParams(key: cardTypeKey),
                          card.getAdditionalParams(key: cardTypeKey))
    }

    func test_setPlayerAdditionalParamsCardAction_playerResolverResolvesNotNil() throws {
        let testKey = "TEST_KEY"
        let testValue = "TEST_VALUE"
        let currentPlayer = try XCTUnwrap(gameRunner.players.currentPlayer)
        let card = Card(name: "Set Params", typeOfTargettedCard: .noTargetCard)
        card.addPlayAction(SetPlayerAdditionalParamsCardAction(
            playerResolver: { _ in currentPlayer },
            key: testKey,
            value: testValue)
        )

        XCTAssertNotEqual(currentPlayer.getAdditionalParams(key: testKey), testValue)

        ActionDispatcher.runAction(
            PlayCardAction(
                player: currentPlayer,
                cards: [card],
                target: .none),
            on: gameRunner
        )

        XCTAssertEqual(currentPlayer.getAdditionalParams(key: testKey), testValue)
    }

    func test_setPlayerAdditionalParamsCardAction_playerResolverResolvesNil() throws {
        let testKey = "TEST_KEY"
        let testValue = "TEST_VALUE"
        let currentPlayer = try XCTUnwrap(gameRunner.players.currentPlayer)
        let card = Card(name: "Set Params", typeOfTargettedCard: .noTargetCard)
        card.addPlayAction(SetPlayerAdditionalParamsCardAction(
            playerResolver: { _ in nil },
            key: testKey,
            value: testValue)
        )

        XCTAssertNotEqual(currentPlayer.getAdditionalParams(key: testKey), testValue)

        ActionDispatcher.runAction(
            PlayCardAction(
                player: currentPlayer,
                cards: [card],
                target: .none),
            on: gameRunner
        )

        XCTAssertNotEqual(currentPlayer.getAdditionalParams(key: testKey), testValue)
    }
}
