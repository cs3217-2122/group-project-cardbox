//
//  MovePlayedPropertyCardEvent.swift
//  CardBox
//
//  Created by Bryann Yeap Kok Keong on 18/4/22.
//

struct MovePlayedPropertyCardEvent: GameEvent {
    let propertyCard: PropertyCard
    let fromDeck: CardCollection
    let toPlayer: Player

    func updateRunner(gameRunner: GameRunnerProtocol) {
        guard let gameRunner = gameRunner as? MonopolyDealGameRunnerProtocol else {
            return
        }

        guard let propertyCardColor = propertyCard.colors.first else {
            return
        }

        guard let toDeck = gameRunner
                .getPropertyAreaByPlayer(toPlayer)
                .getFirstPropertySetOfColor(propertyCardColor),
        toDeck.count < propertyCard.setSize
        else {
            gameRunner.executeGameEvents([
                AddNewPropertyAreaEvent(propertyArea: gameRunner.getPropertyAreaByPlayer(toPlayer),
                                        card: propertyCard,
                                        fromHand: fromDeck)
            ])
            return
        }
        
        gameRunner.executeGameEvents([
            MoveCardsDeckToDeckEvent(cards: [propertyCard], fromDeck: fromDeck, toDeck: toDeck)
        ])

    }
}
