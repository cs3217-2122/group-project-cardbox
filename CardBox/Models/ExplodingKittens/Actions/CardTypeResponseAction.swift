//
//  CardTypeResponseAction.swift
//  CardBox
//
//  Created by Stuart Long on 19/3/22.
//

struct CardTypeResponseAction: Action {
    let target: Player
    let player: Player
    let cardTypeRawValue: String

    func executeGameEvents(gameRunner: GameRunnerReadOnly) {
        PlayerTakenChosenCardFromPlayerCardAction(cardPredicate: {

            guard let cardType = ExplodingKittensUtils.getCardType(card: $0) else {
                // TODO: Exception
                return false
            }

            return cardType.rawValue == cardTypeRawValue

        }).executeGameEvents(gameRunner: gameRunner, args: CardActionArgs(card: nil,
                                                                          player: player,
                                                                          target: .single(target)))
    }
}
