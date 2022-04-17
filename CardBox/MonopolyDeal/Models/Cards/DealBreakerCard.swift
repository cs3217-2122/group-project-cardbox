//
//  DealBreakerCard.swift
//  CardBox
//
//  Created by user213938 on 4/3/22.
//

class DealBreakerCard: ActionCard {
    init() {
        super.init(
            name: "Deal Breaker",
            typeOfTargettedCard: .targetSinglePlayerCard
        )
    }

    override func onPlay(gameRunner: MDGameRunnerProtocol, player: MDPlayer, on target: GameplayTarget) {
        guard gameRunner.gameState is MonopolyDealGameState else {
            return
        }
        guard let targetPlayer = target.getPlayerIfTargetSingle() else {
            return
        }
        let propertyArea = gameRunner.getPropertyAreaByPlayer(targetPlayer)
        let destination = gameRunner.getPropertyAreaByPlayer(player)

        guard propertyArea.numberOfFullSets > 0 else {
            return
        }

        let fullSets = propertyArea.getListOfFullSets()

        let stringRepresentation = fullSets.map { "\($0.setColor)" }

        let callback: (Response) -> Void = { response in
            guard let optionsResponse = response as? OptionsResponse else {
                return
            }

            for propertySet in fullSets where "\(propertySet.setColor)" == optionsResponse.value {
                gameRunner.executeGameEvents([
                    MovePropertyAreaEvent(cardSet: propertySet, fromArea: propertyArea, toArea: destination),
                    MoveCardsDeckToDeckEvent(cards: [self], fromDeck: gameRunner.getHandByPlayer(player),
                                             toDeck: gameRunner.gameplayArea)])
                break
            }
        }

        gameRunner.executeGameEvents([
            SendRequestEvent(
                request: OptionsRequest(description: "Please choose a set to steal",
                                        fromPlayer: player,
                                        toPlayer: player,
                                        callback: Callback(callback),
                                        stringRepresentationOfOptions: stringRepresentation)
                )
            ])

    }

    override func getBankValue() -> Int {
        guard let bankValue = MonopolyDealCardType.dealBreaker.bankValue else {
            assert(false, "Unable to obtain bank value of deal breaker card")
        }
        return bankValue
    }

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
    }
}
