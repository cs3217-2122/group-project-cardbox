//
//  GameRunnerProtocol.swift
//  CardBox
//
//  Created by mactest on 26/03/2022.
//

import SwiftUI

protocol GameRunnerProtocol: AnyObject {
//    var winner: Player? { get set }
//    var isWin: Bool { get set }
//    var players: PlayerCollection { get }
    var cardsDragging: [Card] { get set }
    var gameState: GameState { get set }

    var cardPreview: Card? { get set }
    func setCardPreview(_ card: Card)
    func resetCardPreview()

    // Requests
    var deckPositionRequest: CardPositionRequest { get set }
    var cardTypeRequest: CardTypeRequest { get set }

    func setup()
    func onStartTurn()
    func onEndTurn()
    func onAdvanceNextPlayer()
    func getWinner() -> Player?
    func getNextPlayer() -> Player?
    func checkWinningConditions() -> Bool

    // Must implement this update value
    // use this to notify server as well
    func notifyChanges(_ gameEvents: [GameEvent])

    func executeGameEvents(_ gameEvents: [GameEvent])

    // TODO: remove if not used anywhere
    func updateState(_ gameRunner: GameRunnerProtocol)

    func updateState(gameState: GameState)
}

extension GameRunnerProtocol {
    func executeGameEvents(_ gameEvents: [GameEvent]) {
        gameEvents.forEach { gameEvent in
            gameEvent.updateRunner(gameRunner: self)
        }

        if checkWinningConditions() {
            self.gameState.isWin = true
            self.gameState.winner = getWinner()
        }

        notifyChanges(gameEvents)
    }

    func endPlayerTurn() {
        ActionDispatcher.runAction(EndTurnAction(), on: self)
    }

    func advanceToNextPlayer() {
        guard let nextPlayer = getNextPlayer() else {
            return
        }

        onAdvanceNextPlayer()
        gameState.players.setCurrentPlayer(nextPlayer)
    }
}
