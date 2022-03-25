struct AddCardToDeckEvent<T: Card, V: Player> {
    let card: T

    func updateRunner(gameRunner: GameRunner<T, V>) {
        // gameRunner.deck.addCard(card)
    }
}
