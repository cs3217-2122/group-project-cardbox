enum GameEvent {
    case moveCardToPlayerFromDeck(card: Card, deck: Deck, player: Player)
    case addCardToDeck(card: Card, deck: Deck)
    case addCardToPlayer(card: Card, player: Player)
    case addPlayer(player: Player)
    case displayMessage(message: String)
}
