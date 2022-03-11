protocol GameEvent {
    func updateRunner(gameRunner: GameRunner)
}

// enum GameEvent {
//    case moveCardToPlayerFromDeck(card: Card, deck: Deck, player: Player)
//    case moveCardToGameplayFromPlayer(card: Card, player: Player, gameplayArea: CardCollection)
//    case addCardToDeck(card: Card, deck: Deck)
//    case addCardToPlayer(card: Card, player: Player)
//    case addPlayer(player: Player)
//    case setCurrentPlayer(player: Player)
//    case displayMessage(message: String)
//    case shuffleDeck(deck: Deck)
// }
