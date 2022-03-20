//
//  CardBoxTestsUtil.swift
//  CardBoxTests
//
//  Created by Bryann Yeap Kok Keong on 20/3/22.
//

@testable import CardBox

struct CardBoxTestsUtil {

    static let cardTypeKey = "CARD_TYPE"

    static func areCardCollectionsSame(firstCardCollection: CardCollection,
                                       secondCardCollection: CardCollection,
                                       gameRunner: GameRunnerReadOnly) -> Bool {
        var orderIsSame = true

        for index in 0 ..< gameRunner.deck.count {
            let firstDeckCard = firstCardCollection.getCardByIndex(index)
            let secondDeckCard = secondCardCollection.getCardByIndex(index)
            orderIsSame = orderIsSame && firstDeckCard?.getAdditionalParams(key: cardTypeKey) ==
            secondDeckCard?.getAdditionalParams(key: cardTypeKey)
        }

        return orderIsSame
    }
}
