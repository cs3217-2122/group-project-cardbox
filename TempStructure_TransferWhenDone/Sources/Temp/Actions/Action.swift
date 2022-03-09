protocol Action {
    func generateGameEvents(gameRunner: GameRunnerProtocol) -> [GameEvent]
}
