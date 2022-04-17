//
//  GameEventTests.swift
//  CardBoxTests
//
//  Created by Bryann Yeap Kok Keong on 3/4/22.
//

import XCTest
@testable import CardBox

class GameEventTests: XCTestCase {
    typealias GET = GameEventTests

    var gameRunner: GameRunnerStub!

    var singleTargetCard: CardStub!
    var allTargetCard: CardStub!
    var noTargetCard: CardStub!

    let initialNumOfCardsInDeck = 6

    override func setUpWithError() throws {
        try super.setUpWithError()
        gameRunner = GameRunnerStub()
        singleTargetCard = CardStub(name: "single target card", typeOfTargettedCard: .targetSinglePlayerCard)
        allTargetCard = CardStub(name: "all target card", typeOfTargettedCard: .targetAllPlayersCard)
        noTargetCard = CardStub(name: "no target card", typeOfTargettedCard: .noTargetCard)
    }

    func test_addCardToDeckEvent_singleCard() throws {
        let deck = gameRunner.deck
        XCTAssertEqual(deck.count, initialNumOfCardsInDeck)
        gameRunner.executeGameEvents([AddCardToDeckEvent(card: singleTargetCard, deck: deck)])
        XCTAssertEqual(deck.count, initialNumOfCardsInDeck + 1)
        let bottomCard = try XCTUnwrap(deck.bottomCard)
        XCTAssertEqual(bottomCard, singleTargetCard)
    }

    func test_addCardToDeckEvent_lastCardAddedAtBottomOfDeck() throws {
        let deck = gameRunner.deck
        XCTAssertEqual(deck.count, initialNumOfCardsInDeck)

        for _ in 0..<15 {
            gameRunner.executeGameEvents([AddCardToDeckEvent(card: GET.generateSingleTargetCard(), deck: deck)])
            gameRunner.executeGameEvents([AddCardToDeckEvent(card: GET.generateAllTargetCard(), deck: deck)])
        }

        gameRunner.executeGameEvents([AddCardToDeckEvent(card: noTargetCard, deck: deck)])

        XCTAssertEqual(deck.count, 2 * 15 + 1 + initialNumOfCardsInDeck)
        let bottomCard = try XCTUnwrap(deck.bottomCard)
        XCTAssertEqual(bottomCard, noTargetCard)
    }

    func test_addPlayerEvent_singlePlayer() {
        let players = gameRunner.gameState.players
        XCTAssertEqual(players.count, 0)
        let newPlayer = PlayerStub(name: "Test player")
        gameRunner.executeGameEvents([AddPlayerEvent(player: newPlayer)])
        XCTAssertEqual(players.count, 1)
        guard let addedPlayer = players.getPlayers().first else {
            XCTAssertFalse(true)
            return
        }
        XCTAssertIdentical(addedPlayer, newPlayer)
    }

    func test_addPlayerEvent_multiplePlayers() {
        let players = gameRunner.gameState.players
        XCTAssertEqual(players.count, 0)

        for _ in 0..<15 {
            gameRunner.executeGameEvents([AddPlayerEvent(player: PlayerStub(name: "Test player"))])
        }

        XCTAssertEqual(players.count, 15)
    }

    func test_setCurrentPlayerEvent_playerInGame() {
        let player = PlayerStub(name: "Test player")
        XCTAssertNil(gameRunner.gameState.players.currentPlayer)
        gameRunner.executeGameEvents([AddPlayerEvent(player: player)])
        XCTAssertNotNil(gameRunner.gameState.players.currentPlayer)
        XCTAssertIdentical(gameRunner.gameState.players.currentPlayer, player)
        gameRunner.executeGameEvents([SetCurrentPlayerEvent(player: player)])
        XCTAssertNotNil(gameRunner.gameState.players.currentPlayer)
        XCTAssertIdentical(gameRunner.gameState.players.currentPlayer, player)
    }

    func test_setCurrentPlayerEvent_playerNotInGame() {
        let inGamePlayer = PlayerStub(name: "In-game player")
        let notInGamePlayer = PlayerStub(name: "Not in-game player")
        XCTAssertNil(gameRunner.gameState.players.currentPlayer)
        gameRunner.executeGameEvents([AddPlayerEvent(player: inGamePlayer)])
        XCTAssertNotNil(gameRunner.gameState.players.currentPlayer)
        XCTAssertIdentical(gameRunner.gameState.players.currentPlayer, inGamePlayer)
        gameRunner.executeGameEvents([SetCurrentPlayerEvent(player: notInGamePlayer)])
        XCTAssertNotNil(gameRunner.gameState.players.currentPlayer)
        XCTAssertIdentical(gameRunner.gameState.players.currentPlayer, inGamePlayer)
    }

//     CHANCE OF FALSE NEGATIVE:
//     (1 / (6!/2!2!2!)) = (1 / 90)
    func test_shuffleDeckEvent_deckOrderChanges() {
        let initialDeck = gameRunner.deck.getCards()
        gameRunner.executeGameEvents([ShuffleDeckEvent(deck: gameRunner.deck)])
        let newDeck = gameRunner.deck.getCards()
        XCTAssertFalse(GET.cardCollectionsSame(cardCollection1: initialDeck, cardCollection2: newDeck))
    }

    func test_setPlayerOutOfGameEvent_playerIsSetOutOfGame() {
        let player = PlayerStub(name: "In-game player")
        XCTAssertFalse(player.isOutOfGame)
        gameRunner.executeGameEvents([AddPlayerEvent(player: player), SetPlayerOutOfGameEvent(player: player)])
        XCTAssertTrue(player.isOutOfGame)
    }

    // As can be seen in GameEventTest+Stubs.swift,
    // setup is defined as removing all cards in deck (for simplicity and ease of testing)
    func test_setupEvent_removeAllCardsInDeck() {
        XCTAssertEqual(gameRunner.deck.count, initialNumOfCardsInDeck)
        gameRunner.executeGameEvents([SetupEvent()])
        XCTAssertEqual(gameRunner.deck.count, 6)
    }

    // As can be seen in GameEventTest+Stubs.swift,
    // startturn is defined as removing all cards in deck (for simplicity and ease of testing)
    func test_startTurnEvent_removeAllCardsInDeck() {
        XCTAssertEqual(gameRunner.deck.count, initialNumOfCardsInDeck)
        gameRunner.executeGameEvents([StartTurnEvent()])
        XCTAssertEqual(gameRunner.deck.count, 6)
    }

    // As can be seen in GameEventTest+Stubs.swift,
    // endturn is defined as removing all cards in deck (for simplicity and ease of testing)
    func test_endTurnEvent_removeAllCardsInDeck() {
        XCTAssertEqual(gameRunner.deck.count, initialNumOfCardsInDeck)
        gameRunner.executeGameEvents([EndTurnEvent()])
        XCTAssertEqual(gameRunner.deck.count, 6)
    }

    // As can be seen in GameEventTest+Stubs.swift,
    // endturn is defined as removing all cards in deck (for simplicity and ease of testing)
    func test_endTurnEvent_gameRunnerEndTurn() {
        XCTAssertEqual(gameRunner.deck.count, initialNumOfCardsInDeck)
        gameRunner.endPlayerTurn()
        XCTAssertEqual(gameRunner.deck.count, 6)
    }

    func test_advanceNextPlayerEvent_onlyOnePlayer() {
        let player = PlayerStub(name: "Solo player")
        gameRunner.executeGameEvents([AddPlayerEvent(player: player)])
        XCTAssertIdentical(gameRunner.gameState.players.currentPlayer, player)
        gameRunner.executeGameEvents([AdvanceNextPlayerEvent()])
        XCTAssertIdentical(gameRunner.gameState.players.currentPlayer, player)
    }

    func test_advanceNextPlayerEvent_moreThanOnePlayer() {
        let player1 = PlayerStub(name: "First player")
        let player2 = PlayerStub(name: "Second player")
        gameRunner.executeGameEvents([AddPlayerEvent(player: player1), AddPlayerEvent(player: player2)])
        XCTAssertIdentical(gameRunner.gameState.players.currentPlayer, player1)
        gameRunner.executeGameEvents([AdvanceNextPlayerEvent()])
        XCTAssertIdentical(gameRunner.gameState.players.currentPlayer, player2)
    }

    func test_moveCardsDeckToDeckEvent_playerHasCard() {
        let fromPlayer = PlayerStub(name: "From player")
        let toPlayer = PlayerStub(name: "To player")
        let players = [fromPlayer, toPlayer]
        for player in players {
            let playerHand = CardCollection()
            gameRunner.gameState.playerHands[player.id] = playerHand
            gameRunner.executeGameEvents([AddPlayerEvent(player: fromPlayer)])
        }

        guard let fromPlayerHand = gameRunner.gameState.playerHands[fromPlayer.id],
              let toPlayerHand = gameRunner.gameState.playerHands[toPlayer.id] else {
            XCTAssertFalse(true)
            return
        }
        gameRunner.executeGameEvents([AddCardToDeckEvent(card: singleTargetCard, deck: fromPlayerHand)])

        XCTAssertTrue(fromPlayerHand.containsCard(singleTargetCard))
        XCTAssertFalse(toPlayerHand.containsCard(singleTargetCard))

        gameRunner.executeGameEvents([MoveCardsDeckToDeckEvent(cards: [singleTargetCard],
                                                               fromDeck: fromPlayerHand,
                                                               toDeck: toPlayerHand)])

        XCTAssertFalse(fromPlayerHand.containsCard(singleTargetCard))
        XCTAssertTrue(toPlayerHand.containsCard(singleTargetCard))
    }

    func test_moveCardsDeckToDeckEvent_playerDoesNotHaveCard() {
        let fromPlayer = PlayerStub(name: "From player")
        let toPlayer = PlayerStub(name: "To player")
        let players = [fromPlayer, toPlayer]
        for player in players {
            let playerHand = CardCollection()
            gameRunner.gameState.playerHands[player.id] = playerHand
            gameRunner.executeGameEvents([AddPlayerEvent(player: fromPlayer)])
        }

        guard let fromPlayerHand = gameRunner.gameState.playerHands[fromPlayer.id],
              let toPlayerHand = gameRunner.gameState.playerHands[toPlayer.id] else {
            XCTAssertFalse(true)
            return
        }

        XCTAssertFalse(fromPlayerHand.containsCard(singleTargetCard))
        XCTAssertFalse(toPlayerHand.containsCard(singleTargetCard))

        gameRunner.executeGameEvents([MoveCardsDeckToDeckEvent(cards: [singleTargetCard],
                                                               fromDeck: fromPlayerHand,
                                                               toDeck: toPlayerHand)])

        XCTAssertFalse(fromPlayerHand.containsCard(singleTargetCard))
        XCTAssertFalse(toPlayerHand.containsCard(singleTargetCard))
    }

    func test_moveCardsDeckToDeckEvent_playerHasAllTheCards() {
        let fromPlayer = PlayerStub(name: "From player")
        let toPlayer = PlayerStub(name: "To player")
        let players = [fromPlayer, toPlayer]
        for player in players {
            let playerHand = CardCollection()
            gameRunner.gameState.playerHands[player.id] = playerHand
            gameRunner.executeGameEvents([AddPlayerEvent(player: fromPlayer)])
        }

        guard let fromPlayerHand = gameRunner.gameState.playerHands[fromPlayer.id],
              let toPlayerHand = gameRunner.gameState.playerHands[toPlayer.id] else {
            XCTAssertFalse(true)
            return
        }

        gameRunner.executeGameEvents([AddCardToDeckEvent(card: singleTargetCard, deck: fromPlayerHand)])
        gameRunner.executeGameEvents([AddCardToDeckEvent(card: allTargetCard, deck: fromPlayerHand)])

        XCTAssertTrue(fromPlayerHand.containsCard(singleTargetCard))
        XCTAssertTrue(fromPlayerHand.containsCard(allTargetCard))
        XCTAssertFalse(toPlayerHand.containsCard(singleTargetCard))
        XCTAssertFalse(toPlayerHand.containsCard(allTargetCard))

        gameRunner.executeGameEvents([MoveCardsDeckToDeckEvent(cards: [singleTargetCard, allTargetCard],
                                                               fromDeck: fromPlayerHand,
                                                               toDeck: toPlayerHand)])

        XCTAssertFalse(fromPlayerHand.containsCard(singleTargetCard))
        XCTAssertFalse(fromPlayerHand.containsCard(allTargetCard))
        XCTAssertTrue(toPlayerHand.containsCard(singleTargetCard))
        XCTAssertTrue(toPlayerHand.containsCard(allTargetCard))
    }

    func test_moveCardsDeckToDeckEvent_playerDoesNotHaveAllTheCards() {
        let fromPlayer = PlayerStub(name: "From player")
        let toPlayer = PlayerStub(name: "To player")
        let players = [fromPlayer, toPlayer]
        for player in players {
            let playerHand = CardCollection()
            gameRunner.gameState.playerHands[player.id] = playerHand
            gameRunner.executeGameEvents([AddPlayerEvent(player: fromPlayer)])
        }

        guard let fromPlayerHand = gameRunner.gameState.playerHands[fromPlayer.id],
              let toPlayerHand = gameRunner.gameState.playerHands[toPlayer.id] else {
            XCTAssertFalse(true)
            return
        }

        gameRunner.executeGameEvents([AddCardToDeckEvent(card: singleTargetCard, deck: fromPlayerHand)])

        XCTAssertTrue(fromPlayerHand.containsCard(singleTargetCard))
        XCTAssertFalse(fromPlayerHand.containsCard(allTargetCard))
        XCTAssertFalse(toPlayerHand.containsCard(singleTargetCard))
        XCTAssertFalse(toPlayerHand.containsCard(allTargetCard))

        gameRunner.executeGameEvents([MoveCardsDeckToDeckEvent(cards: [singleTargetCard, allTargetCard],
                                                               fromDeck: fromPlayerHand,
                                                               toDeck: toPlayerHand)])

        XCTAssertTrue(fromPlayerHand.containsCard(singleTargetCard))
        XCTAssertFalse(fromPlayerHand.containsCard(allTargetCard))
        XCTAssertFalse(toPlayerHand.containsCard(singleTargetCard))
        XCTAssertFalse(toPlayerHand.containsCard(allTargetCard))
    }
}
