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
    var cardsDragging: [Card] { get set }

    var cardPreview: Card? { get set }
    func setCardPreview(_ card: Card)
    func resetCardPreview()

    // Requests
    var deckPositionRequest: CardPositionRequest { get set }
    var cardTypeRequest: CardTypeRequest { get set }
    var globalRequests: [IntRequest] { get set } // TODO: Generalise to any type of request
    var globalResponses: [IntResponse] { get set } // TODO: Generalise to any type of response
    var localPendingRequests: [IntRequest] { get set } // TODO: Generalise to any type of response

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

    func updateState(_ gameRunner: GameRunnerProtocol)
//    func updateStateMutable(_ gameRunner: GameRunnerProtocol)
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

        notifyChanges(gameEvents)
        resolvePendingRequests()
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

    func resolvePendingRequests() {
        for request in localPendingRequests {
            let requestId = request.id
            for response in globalResponses where response.requestId == requestId {
                globalResponses.removeAll(where: { $0.id == response.id })
                localPendingRequests.removeAll(where: { $0.id == requestId })
                globalRequests.removeAll(where: { $0.id == requestId })
                request.callback(response.value)
            }
        }
    }
}
