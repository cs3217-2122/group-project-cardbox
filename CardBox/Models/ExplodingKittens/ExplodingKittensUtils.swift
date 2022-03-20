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

    static let attackCountKey = "ATTACK_COUNT"
    static let trueString = "true"
    static let falseString = "false"

    static func getAttackCount(player: Player) -> Int {
        guard let value = player.getAdditionalParams(key: attackCountKey) else {
            return 0
        }
        return Int(value) ?? 0
    }

    static func setAttackCount(player: Player, attackCount: Int) {
        player.setAdditionalParams(key: attackCountKey, value: String(attackCount))
    }
}
