//
//  ExplodingKittensGameRunnerProtocol.swift
//  CardBox
//
//  Created by mactest on 26/03/2022.
//

import SwiftUI

protocol ExplodingKittensGameRunnerProtocol: GameRunnerProtocol {
    var deck: CardCollection { get }
    var playerHands: [UUID: CardCollection] { get }
    var gameplayArea: CardCollection { get }

    var cardsPeeking: [Card] { get }
    var isShowingPeek: Bool { get }

    var deckPositionRequest: CardPositionRequest { get }

    func setCardsPeeking(cards: [Card])
    func getHandByPlayer(_ player: Player) -> CardCollection?
}
