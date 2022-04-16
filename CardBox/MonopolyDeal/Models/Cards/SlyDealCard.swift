//
//  SlyDealCard.swift
//  CardBox
//
//  Created by Bryann Yeap Kok Keong on 16/4/22.
//

class SlyDealCard: MonopolyDealCard {
    init() {
        super.init(
            name: "Sly Deal",
            typeOfTargettedCard: .targetSingleDeckCard,
            type: .slyDeal
        )
    }

    override func onPlay(gameRunner: MDGameRunnerProtocol, player: MDPlayer, on target: GameplayTarget) {
        if case .deck(let collection) = target {
            if let collection = collection {

                guard let gameState = gameRunner.gameState as? MonopolyDealGameState,
                      gameState.checkIfPropertySetIsFullSet(collection) else {
                          return
                      }

                guard var propertyCard = collection.getCards()
                        .first(where: { $0 is PropertyCard }) as? PropertyCard else {
                            return
                }

                if let wildCard = collection.getCard(where: { card in
                    guard let propertyCard = card as? PropertyCard else {
                        return false
                    }
                    return propertyCard.colors.count > 1
                }) as? PropertyCard {
                    propertyCard = wildCard
                }

                let hand = gameRunner.getHandByPlayer(player)
                let requestDescription = "You have recieved a property card with the following colour(s): " +
                propertyCard.getStringRepresentationOfColors() +
                "Please choose a property set to place it in, or make a new set."

                gameRunner.executeGameEvents([
                    MoveCardsDeckToDeckEvent(cards: [self], fromDeck: hand, toDeck: gameRunner.gameplayArea),
                    PropertyAreaDeckRequestEvent(propertyCard: propertyCard,
                                                 fromDeck: collection,
                                                 requestDescription: requestDescription,
                                                 player: player)
                ])
            }
        }
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
