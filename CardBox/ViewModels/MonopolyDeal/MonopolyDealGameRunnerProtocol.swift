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
    var playerPropertyArea: [UUID: CardCollection] { get }
    var playerMoneyArea: [UUID: CardCollection] { get }
    var gameplayArea: CardCollection { get }

    func getHandByPlayer(_ player: Player) -> CardCollection
    func getPropertyByPlayer(_ player: Player) -> CardCollection
}
