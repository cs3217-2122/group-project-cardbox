//
//  ExplodingKittensUtils.swift
//  CardBox
//
//  Created by mactest on 17/03/2022.
//

struct ExplodingKittensUtils {
    static let cardTypeKey = "CARD_TYPE"

    static func getCardType(card: Card) -> ExplodingKittensCardType? {
        guard let typeParam = card.getAdditionalParams(key: cardTypeKey) else {
            return nil
        }
        return ExplodingKittensCardType(rawValue: typeParam)
    }

    static func setCardType(card: Card, type: ExplodingKittensCardType) {
        card.setAdditionalParams(key: cardTypeKey, value: type.rawValue)
    }

    static func getAllCardTypes() -> [ExplodingKittensCardType] {
        ExplodingKittensCardType.allCases
    }
}
