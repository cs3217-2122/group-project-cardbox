//
//  GameRunnerProtocol.swift
//  CardBox
//
//  Created by mactest on 26/03/2022.
//

import SwiftUI

protocol GameRunnerProtocol: AnyObject {
    var winner: Player? { get set }
    var isWin: Bool { get set }
    var players: PlayerCollection { get }

    // Might remove
    var cardPreview: Card? { get }
    func setCardPreview(_ card: Card)
    func resetCardPreview()

    func setup()
    func onStartTurn()
    func onEndTurn()
    func onAdvanceNextPlayer()
    func getWinner() -> Player?
    func getNextPlayer() -> Player?
    func checkWinningConditions() -> Bool

    // Must implement this update value
    // use this to notify server as well
    func notifyChanges()

    func executeGameEvents(_ gameEvents: [GameEvent])
}

extension GameRunnerProtocol {
    func executeGameEvents(_ gameEvents: [GameEvent]) {
        gameEvents.forEach { gameEvent in
            gameEvent.updateRunner(gameRunner: self)
        }

        if checkWinningConditions() {
            self.isWin = true
            self.winner = getWinner()
        }

        notifyChanges()
    }

    func endPlayerTurn() {
        ActionDispatcher.runAction(EndTurnAction(), on: self)
    }

    func advanceToNextPlayer() {
        guard let nextPlayer = getNextPlayer() else {
            return
        }

        onAdvanceNextPlayer()
        players.setCurrentPlayer(nextPlayer)
    }
}
