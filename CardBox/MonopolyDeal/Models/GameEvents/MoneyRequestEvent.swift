//
//  RequestForMoneyEvent.swift
//  CardBox
//
//  Created by Bryann Yeap Kok Keong on 16/4/22.
//

struct MoneyRequestEvent: GameEvent {
    let moneyAmount: Int
    let requestDescription: String
    let requestSender: MonopolyDealPlayer
    let requestReciepient: MonopolyDealPlayer

    func updateRunner(gameRunner: GameRunnerProtocol) {
        guard let gameRunner = gameRunner as? MonopolyDealGameRunnerProtocol else {
            return
        }

        let payableCards = self.getPayableCards(of: requestReciepient, gameRunner: gameRunner)

        let callback: (Response) -> Void = { response in
            guard let optionsResponse = response as? OptionsResponse else {
                return
            }

            guard let chosenCard = payableCards
                    .first(where: { $0.name == optionsResponse.value }) as? MonopolyDealCard else {
                return
            }

            if self.getPropertyCards(of: requestReciepient, gameRunner: gameRunner).contains(chosenCard) {
                self.sendPropertyAreaDeckRequest(chosenCard: chosenCard, fromPlayer: requestReciepient,
                                                 toPlayer: requestSender, gameRunner: gameRunner)
            } else {
                let fromDeck = gameRunner.getMoneyAreaByPlayer(requestReciepient)
                let toDeck = gameRunner.getMoneyAreaByPlayer(requestSender)
                gameRunner.executeGameEvents([
                    MoveCardsDeckToDeckEvent(cards: [chosenCard], fromDeck: fromDeck, toDeck: toDeck)
                ])
            }

            if chosenCard.getBankValue() < moneyAmount {
                let remainingAmountRequired = moneyAmount - chosenCard.getBankValue()
                let message = "You needed to pay \(moneyAmount), but only payed \(chosenCard.getBankValue()). " +
                "Please pay the remaining \(remainingAmountRequired)."
                gameRunner.executeGameEvents([
                    MoneyRequestEvent(moneyAmount: remainingAmountRequired, requestDescription: message,
                                      requestSender: requestSender, requestReciepient: requestReciepient)
                ])
            }
        }

        let request = OptionsRequest(description: requestDescription, fromPlayer: requestSender,
                                     toPlayer: requestReciepient, callback: Callback(callback),
                                     stringRepresentationOfOptions: Array(Set(payableCards.map({ $0.name }))))

        gameRunner.executeGameEvents([SendRequestEvent(request: request)])
    }

    private func getPayableCards(of player: MonopolyDealPlayer,
                                 gameRunner: MonopolyDealGameRunnerProtocol) -> [Card] {
        var payableCards: [Card] = []

        let targetPropertyCards = getPropertyCards(of: player, gameRunner: gameRunner)
        payableCards.append(contentsOf: targetPropertyCards)
        let targetMoneyCards = getMoneyCards(of: player, gameRunner: gameRunner)
        payableCards.append(contentsOf: targetMoneyCards)
        return payableCards
    }

    private func getPropertyCards(of player: MonopolyDealPlayer,
                                  gameRunner: MonopolyDealGameRunnerProtocol) -> [Card] {
        Array(gameRunner.getPropertyAreaByPlayer(player)
                .getArea()
                .map({ $0.getCards() })
                .joined())
    }

    private func getMoneyCards(of player: MonopolyDealPlayer,
                               gameRunner: MonopolyDealGameRunnerProtocol) -> [Card] {
        gameRunner.getMoneyAreaByPlayer(player).getCards()
    }

    private func sendPropertyAreaDeckRequest(chosenCard: Card,
                                             fromPlayer: MonopolyDealPlayer,
                                             toPlayer: MonopolyDealPlayer,
                                             gameRunner: MonopolyDealGameRunnerProtocol) {
        guard let propertyCard = chosenCard as? PropertyCard else {
            return
        }

        let requestDescription = "You have recieved a property card with the following colour(s): " +
        propertyCard.getStringRepresentationOfColors() + "\n" +
        "Please choose a property set to place it in, or make a new set."
        let propertyArea = gameRunner.getPropertyAreaByPlayer(fromPlayer).getArea()

        guard let fromDeck = propertyArea.first(where: { $0.containsCard(chosenCard) }) else {
            return
        }

        gameRunner.executeGameEvents([
            PropertyAreaDeckRequestEvent(propertyCard: propertyCard,
                                         fromDeck: fromDeck,
                                         requestDescription: requestDescription,
                                         player: toPlayer)
        ])
    }
}
