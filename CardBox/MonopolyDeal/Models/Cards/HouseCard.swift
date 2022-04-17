//
//  HouseCard.swift
//  CardBox
//
//  Created by user213938 on 4/3/22.
//

class HouseCard: ActionCard {
    init() {
        super.init(
            name: "House",
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

                let hand = gameRunner.getHandByPlayer(player)

                gameRunner.executeGameEvents([
                    MoveCardsDeckToDeckEvent(cards: [self], fromDeck: hand, toDeck: collection)
                ])
            }
        }
    }

    override func getBankValue() -> Int {
        guard let bankValue = MonopolyDealCardType.house.bankValue else {
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
