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

    let cardTypeKey = "CARD_TYPE"

//    var singleTargetCard: Card!
//    var allTargetCard: Card!
//    var noTargetCard: Card!

    let initialNumOfCardsInDeck = 6
    let numOfPlayers = 2

    override func setUpWithError() throws {
        try super.setUpWithError()
        gameRunner = getAndSetupGameRunnerInstance()
//        singleTargetCard = generateSingleTargetCard()
//        allTargetCard = generateAllTargetCard()
//        noTargetCard = generateNoTargetCard()
    }

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

    func test_playerInsertCardIntoDeckCard_playerHasCard() throws {
        let currentPlayer = try XCTUnwrap(gameRunner.players.currentPlayer)
        currentPlayer.addCard(generateSingleTargetCard())
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

        XCTAssertNotEqual(initialNthCardInDeck?.getAdditionalParams(key: cardTypeKey),
                          newNthCardInDeck?.getAdditionalParams(key: cardTypeKey))
        XCTAssertEqual(newNthCardInDeck?.getAdditionalParams(key: cardTypeKey),
                       card.getAdditionalParams(key: cardTypeKey))
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

}
