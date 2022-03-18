struct InitDeckWithCardCombosAction: Action {
    let cardCombos: [CardCombo]
    
    func executeGameEvents(gameRunner: GameRunnerReadOnly) {
        // Only can be used in init phase
        guard gameRunner.state == .initialize else {
            return
        }
        
        let addCardCombos: [GameEvent] = cardCombos.map { cardCombo in
            AddCardComboToDeckEvent(cardCombo: cardCombo)
        }

        gameRunner.executeGameEvents(addCardCombos)
    }
}
