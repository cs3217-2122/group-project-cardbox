//
//  ExplodingKittensGameRunnerProtocol.swift
//  CardBox
//
//  Created by mactest on 26/03/2022.
//

import SwiftUI

protocol ExplodingKittensGameRunnerProtocol: GameRunnerProtocol {
    var cardsPeeking: [Card] { get }
    var isShowingPeek: Bool { get }
}
