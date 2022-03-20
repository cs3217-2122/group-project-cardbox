//
//  PlayerCollection.swift
//  CardBoxTests
//
//  Created by mactest on 19/03/2022.
//

import XCTest
@testable import CardBox

class PlayerCollectionTests: XCTestCase {
    func testEmptyCollection() {
        let collection = PlayerCollection()

        assert(collection.isEmpty)
        assert(collection.currentPlayer == nil)
    }

    func testSinglePlayer() {
        let collection = PlayerCollection()

        let player1 = Player(name: "player 1")
        collection.addPlayer(player1)

        assert(!collection.isEmpty)
        assert(collection.count == 1)
        assert(collection.currentPlayer === player1)
    }

    func testGetPlayerByIndex() {
        let collection = PlayerCollection()

        let player1 = Player(name: "player 1")
        let player2 = Player(name: "player 2")

        collection.addPlayer(player1)
        collection.addPlayer(player2)

        assert(collection.getPlayerByIndex(0) === player1)
        assert(collection.getPlayerByIndex(1) === player2)
    }

    func testGetPlayerByIndexOutOfBounds() {
        let collection = PlayerCollection()

        let player1 = Player(name: "player 1")
        let player2 = Player(name: "player 2")

        collection.addPlayer(player1)
        collection.addPlayer(player2)

        let outOfBoundPlayer1 = collection.getPlayerByIndex(3)
        assert(outOfBoundPlayer1 == nil)

        let outOfBoundPlayer2 = collection.getPlayerByIndex(-1)
        assert(outOfBoundPlayer2 == nil)
    }

    func testAddDuplicatePlayer() {
        let collection = PlayerCollection()

        let player1 = Player(name: "player 1")

        collection.addPlayer(player1)
        collection.addPlayer(player1)

        assert(collection.count == 1)
    }

    func testSetCurrentPlayerNonExistant() {
        let collection = PlayerCollection()

        let player1 = Player(name: "player 1")
        collection.addPlayer(player1)
        let player2 = Player(name: "player 2")
        collection.setCurrentPlayer(player2)

        assert(collection.currentPlayer === player1)
    }

    func testGetPlayerByIndexAfterCurrent() {
        let collection = PlayerCollection()

        let player1 = Player(name: "player 1")
        let player2 = Player(name: "player 2")
        let player3 = Player(name: "player 3")

        collection.addPlayer(player1)
        collection.addPlayer(player2)
        collection.addPlayer(player3)

        collection.setCurrentPlayer(player2)

        let nextPlayerAfterCurrent = collection.getPlayerByIndexAfterCurrent(1)
        assert(nextPlayerAfterCurrent === player3)

        let nextPlayerByIndex = collection.getPlayerByIndex(1)
        assert(nextPlayerByIndex === player2)
    }
    func testGetPlayerByIndexAfterCurrentNegativeIndex() {
        let collection = PlayerCollection()

        let player1 = Player(name: "player 1")
        let player2 = Player(name: "player 2")

        collection.addPlayer(player1)
        collection.addPlayer(player2)

        let negativeIndexPlayer = collection.getPlayerByIndexAfterCurrent(-1)
        assert(negativeIndexPlayer == nil)
    }

    func testGetPlayerByIndexAfterCurrentOutOfBoundIndex() {
        let collection = PlayerCollection()

        let player1 = Player(name: "player 1")
        let player2 = Player(name: "player 2")
        let player3 = Player(name: "player 3")

        collection.addPlayer(player1)
        collection.addPlayer(player2)
        collection.addPlayer(player3)

        collection.setCurrentPlayer(player2)

        let outOfBoundPlayer = collection.getPlayerByIndexAfterCurrent(20)
        assert(outOfBoundPlayer === player1)
    }
}
