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
            typeOfTargettedCard: .targetSingleDeckCard
        )
    }

    override func onPlay(gameRunner: MDGameRunnerProtocol, player: MDPlayer, on target: GameplayTarget) {
        if case .deck(let collection) = target {
            if let collection = collection {

                guard let gameState = gameRunner.gameState as? MonopolyDealGameState,
                      gameState.checkIfPropertySetIsFullSet(collection) else {
                          return
                      }

                guard let propertyCard = collection.getCards()
                        .first(where: { $0 is PropertyCard }) as? PropertyCard else {
                            return
                }

//                if let wildCard = collection.getCard(where: { card in
//                    guard let propertyCard = card as? PropertyCard else {
//                        return false
//                    }
//                    return propertyCard.colors.count > 1
//                }) as? PropertyCard {
//                    propertyCard = wildCard
//                }

                guard let propertyCardColor = propertyCard.colors.first else {
                    return
                }

                guard let toDeck = gameRunner
                        .getPropertyAreaByPlayer(player)
                        .getFirstPropertySetOfColor(propertyCardColor) else {
                    return
                }

                let hand = gameRunner.getHandByPlayer(player)
                gameRunner.executeGameEvents([
                    MoveCardsDeckToDeckEvent(cards: [self], fromDeck: hand, toDeck: gameRunner.gameplayArea),
                    MoveCardsDeckToDeckEvent(cards: [propertyCard], fromDeck: collection, toDeck: toDeck)
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
