//
//  PropertyAreaDeckRequestEvent.swift
//  CardBox
//
//  Created by Bryann Yeap Kok Keong on 16/4/22.
//

// Moves a property card from a deck to a player's property area based on which property set the player chooses
struct PropertyAreaDeckRequestEvent: GameEvent {
    let propertyCard: PropertyCard
    let fromDeck: CardCollection
    let requestDescription: String
    let player: MonopolyDealPlayer

    private let newPropertyDeckOption = "Make new property set"

    func updateRunner(gameRunner: GameRunnerProtocol) {
        guard let gameRunner = gameRunner as? MonopolyDealGameRunnerProtocol else {
            return
        }

        let hand = gameRunner.getHandByPlayer(player)
        gameRunner.executeGameEvents([
            MoveCardsDeckToDeckEvent(cards: [propertyCard], fromDeck: fromDeck, toDeck: hand)
        ])

        let propertyArea = gameRunner.getPropertyAreaByPlayer(player)

        let callback: (Response) -> Void = { response in
            guard let optionsResponse = response as? OptionsResponse else {
                return
            }

            if optionsResponse.value == newPropertyDeckOption {
                propertyCard.onPlay(gameRunner: gameRunner, player: player, on: .deck(nil))
            } else if let optionsResponseValue = Int(optionsResponse.value) {
                let deckIndex = optionsResponseValue - 1
                let chosenDeck = propertyArea.getArea()[deckIndex]
                propertyCard.onPlay(gameRunner: gameRunner, player: player, on: .deck(chosenDeck))
            }

            if hand.containsCard(propertyCard) {
                gameRunner.executeGameEvents([
                    PropertyAreaDeckRequestEvent(propertyCard: propertyCard,
                                                 fromDeck: hand,
                                                 requestDescription: "Please choose a property set that corresponds " +
                                                 "to any of the colors of the property card: " +
                                                 propertyCard.getStringRepresentationOfColors(),
                                                 player: player)
                ])
            }
        }

        let request = OptionsRequest(description: requestDescription,
                                     fromPlayer: player,
                                     toPlayer: player,
                                     callback: Callback(callback),
                                     stringRepresentationOfOptions: getOptions(propertyArea: propertyArea))

        gameRunner.executeGameEvents([SendRequestEvent(request: request)])

    }

    private func getOptions(propertyArea: MonopolyDealPlayerPropertyArea) -> [String] {
        var deckOptions = (1...propertyArea.count).map({ String($0) })
        deckOptions.append(newPropertyDeckOption)
        return deckOptions
    }
}
