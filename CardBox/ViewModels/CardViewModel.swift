//
//  CardViewModel.swift
//  CardBox
//
//  Created by mactest on 13/03/2022.
//

import SwiftUI

class CardViewModel: ObservableObject {

    var card: Card?
    var isFaceUp: Bool
    @Published var isSelected: Bool

    var imageName: String? {
        if let card = card {
            return AssetFetcher.getImageName(card: card)
        }
        return nil
    }

    var cardTitle: String? {
        if let card = card {
            return card.name
        }
        return nil
    }

    var cardDescription: String? {
        if let card = card {
            return card.cardDescription
        }
        return nil
    }

    init(card: Card? = nil, isFaceUp: Bool = false) {
        self.card = card
        self.isFaceUp = false
        self.isSelected = false
    }
}
