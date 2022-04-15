//
//  DealBreakerCard.swift
//  CardBox
//
//  Created by user213938 on 4/3/22.
//

class DealBreakerCard: MonopolyDealCard {
    init() {
        super.init(
            name: "Deal Breaker",
            typeOfTargettedCard: .targetSingleDeckCard,
            type: .dealBreaker
        )
    }

    override func onPlay(gameRunner: MDGameRunnerProtocol, player: MDPlayer, on target: GameplayTarget) {
        guard let gameState = gameRunner.gameState as? MonopolyDealGameState else {
            return
        }

        if case .deck(let deck) = target {
            if let deck = deck {
                let hand = gameRunner.getHandByPlayer(player)

                guard let baseCard = deck.topCard as? PropertyCard else {
                    return
                }

                let baseColors = baseCard.colors

                guard baseColors.count == 1 else {
                    return
                }
                let baseSize = baseCard.setSize

                let playerPropertyArea = gameRunner.getPropertyAreaByPlayer(player)

                // Only remove full sets
                if baseSize == gameState.deck.count {
                    // TODO: Fix from area
                    gameRunner.executeGameEvents([
                        MovePropertyAreaEvent(cardSet: deck, fromArea: playerPropertyArea, toArea: playerPropertyArea),
                        MoveCardsDeckToDeckEvent(cards: [self], fromDeck: hand, toDeck: gameState.gameplayArea)
                    ])

                }
            }
        }
    }

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
    }
}
