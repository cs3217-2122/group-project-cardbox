//
//  MonopolyDealCardType.swift
//  CardBox
//
//  Created by user213938 on 4/2/22.
//

enum MonopolyDealCardType: String, CaseIterable {
    case property = "property"
    case dealBreaker = "deal_breaker"
    case doubleRent = "double_rent"
    case forcedDeal = "forced_deal"
    case hotel = "hotel"
    case house = "house"
    case birthday = "birthday"
    case passGo = "pass_go"
    case money = "money"

    var initialFrequency: Int {
        switch self {
        case .property:
            return 0
        case .dealBreaker:
            return 2
        case .doubleRent:
            return 2
        case .forcedDeal:
            return 4
        case .hotel:
            return 3
        case .house:
            return 3
        case .birthday:
            return 3
        case .passGo:
            return 10
        case .money:
            return 0
        }
    }
}
