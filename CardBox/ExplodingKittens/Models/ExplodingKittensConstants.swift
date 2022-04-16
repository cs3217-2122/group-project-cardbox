//
//  ExplodingKittensUtils.swift
//  CardBox
//
//  Created by mactest on 17/03/2022.
//

struct ExplodingKittensConstants {
    static var allCardTypes: [ExplodingKittensCardType] {
        ExplodingKittensCardType.allCases
    }

    static let nonActionCards: [ExplodingKittensCard.Type] = [
        RandomCard.self
    ]
    static let actionCards: [ExplodingKittensCard.Type] = [
        AttackCard.self,
        FavorCard.self,
        SeeTheFutureCard.self,
        ShuffleCard.self,
        SkipCard.self
    ]
    static var playableCards: [ExplodingKittensCard.Type] {
        nonActionCards + actionCards
    }

    private static func getCardTypeFromObject_1(card: ExplodingKittensCard) -> ExplodingKittensCardType? {
        switch card {
        case is AttackCard:
            return .attack
        case is BombCard:
            return .bomb
        case is DefuseCard:
            return .defuse
        case is FavorCard:
            return .favor
        case is SeeTheFutureCard:
            return .seeTheFuture
        default:
            return nil
        }
    }

    private static func getCardTypeFromObject_2(card: ExplodingKittensCard) -> ExplodingKittensCardType? {
        switch card {
        case is ShuffleCard:
            return .shuffle
        case is SkipCard:
            return .skip
        case is RandomCard:
            guard let rCard = card as? RandomCard else {
                return nil
            }
            switch rCard.randomCardType {
            case .random1:
                return .random1
            case .random2:
                return .random2
            case .random3:
                return .random3
            }
        default:
            return nil
        }
    }

    static func getCardTypeFromObject(card: ExplodingKittensCard) -> ExplodingKittensCardType? {
        let type1 = ExplodingKittensConstants.getCardTypeFromObject_1(card: card)
        if type1 != nil {
            return type1
        }

        let type2 = ExplodingKittensConstants.getCardTypeFromObject_2(card: card)
        return type2
    }
}
