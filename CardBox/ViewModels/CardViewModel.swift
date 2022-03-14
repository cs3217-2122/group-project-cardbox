//
//  CardViewModel.swift
//  CardBox
//
//  Created by mactest on 13/03/2022.
//

import SwiftUI

class CardViewModel: ObservableObject {
    @Published var card: Card

    init(card: Card) {
        self.card = card
    }
}
