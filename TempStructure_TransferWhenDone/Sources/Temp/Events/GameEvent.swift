protocol GameEvent {
    associatedtype T: Card
    associatedtype V: Player

    func updateRunner(gameRunner: GameRunner<T, V>)
}
