//
//  MonopolyDealGameRunnerProtocol.swift
//  CardBox
//
//  Created by Temp on 31.03.2022.
//

import SwiftUI

protocol MonopolyDealGameRunnerProtocol: GameRunnerProtocol {
    var deck: CardCollection { get }
    var playerHands: [UUID: CardCollection] { get }
    var playerPropertyArea: [UUID: MonopolyDealPlayerPropertyArea] { get }
    var playerMoneyArea: [UUID: CardCollection] { get }
    var gameplayArea: CardCollection { get }

    func getPropertyAreaByPlayer(_ player: Player) -> MonopolyDealPlayerPropertyArea
    func getMoneyAreaByPlayer(_ player: Player) -> CardCollection
}
