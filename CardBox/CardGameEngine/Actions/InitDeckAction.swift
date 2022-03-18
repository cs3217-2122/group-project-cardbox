struct InitDeckAction: Action {
    let cards: [Card]
    let cardCombos: [CardCombo]
    
    func executeGameEvents(gameRunner: GameRunnerReadOnly) {
        // Only can be used in init phase
        guard gameRunner.state == .initialize else {
            return
        }

        let addCards: [GameEvent] = cards.map { card in
            AddCardToDeckEvent(card: card)
        }
        
        let addCardCombos: [GameEvent] = cardCombos.map { cardCombo in
            AddCardComboToDeckEvent(cardCombo: cardCombo)
        }

        gameRunner.executeGameEvents(addCards)
        gameRunner.executeGameEvents(addCardCombos)
    }
}
