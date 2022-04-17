//
//  SlyDealCard.swift
//  CardBox
//
//  Created by Bryann Yeap Kok Keong on 16/4/22.
//

class SlyDealCard: ActionCard {
    init() {
        super.init(
            name: "Sly Deal",
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
        let nonFullSets = propertyArea.getListOfNonFullSets()

        guard !nonFullSets.isEmpty else {
            return
        }
        var pArray: [Card] = []

        for propertySet in nonFullSets {
            for pCard in propertySet.cards {
                pArray.append(pCard)
            }
        }

        let stringRepresentation = pArray.map { $0.name }

        let callback: (Response) -> Void = { response in
            guard let optionsResponse = response as? OptionsResponse else {
                return
            }

            for propertySet in nonFullSets {
                for pCard in propertySet.cards {
                    guard let pCard = pCard as? PropertyCard else {
                        continue
                    }
                    guard pCard.name == optionsResponse.value else {
                        continue
                    }
                    propertySet.removeCard(pCard)
                    gameRunner.executeGameEvents([
                        AddNewPropertyAreaEvent(propertyArea: destination,
                                                card: pCard, fromHand: CardCollection()),
                        MoveCardsDeckToDeckEvent(cards: [self], fromDeck: gameRunner.getHandByPlayer(player),
                                                 toDeck: gameRunner.gameplayArea)])
                    break

                }

                }
            }

        gameRunner.executeGameEvents([
            SendRequestEvent(
                request: OptionsRequest(description: "Please choose a card to steal",
                                        fromPlayer: player,
                                        toPlayer: player,
                                        callback: Callback(callback),
                                        stringRepresentationOfOptions: stringRepresentation)
                )
            ])
    }

    override func getBankValue() -> Int {
        guard let bankValue = MonopolyDealCardType.slyDeal.bankValue else {
            assert(false, "Unable to obtain bank value of house card")
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
