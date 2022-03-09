protocol GameRunnerProtocol {
    var deck: Deck { get }
    var currentPlayer: Player? { get }
    var state: GameState { get }

    func refreshGame()
}
