//
//  GameRunnerProtocol.swift
//  CardBox
//
//  Created by mactest on 26/03/2022.
//

protocol GameRunnerProtocol: AnyObject {
    var cardsDragging: [Card] { get set }
    var cardsSelected: [Card] { get set }
    var gameState: GameState { get set }
    var localPendingRequests: [Request] { get set }

    var cardPreview: Card? { get set }
    func setCardPreview(_ card: Card)
    func resetCardPreview()

    var cardHeight: Int { get }
    var cardWidth: Int { get }

    func setup()
    func onStartTurn()
    func onEndTurn()
    func onAdvanceNextPlayer()
    func getWinner() -> Player?
    func getNextPlayer() -> Player?
    func checkWinningConditions() -> Bool
    func getHandByPlayer(_ player: Player) -> CardCollection

    // Must implement this update value
    // use this to notify server as well
    func notifyChanges(_ gameEvents: [GameEvent])
    func executeGameEvents(_ gameEvents: [GameEvent])
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
        gameState.players.setCurrentPlayer(nextPlayer)
    }

    func resolvePendingRequests() {
        for request in self.localPendingRequests {
            let requestId = request.id
            for response in gameState.globalResponses.getCollection() where response.requestId == requestId {
                gameState.globalResponses.removeAll(where: { $0.id == response.id })
                self.localPendingRequests.removeAll(where: { $0.id == requestId })
                gameState.globalRequests.removeAll(where: { $0.id == requestId })
                request.callback.callback(response)
            }
        }
    }
}
