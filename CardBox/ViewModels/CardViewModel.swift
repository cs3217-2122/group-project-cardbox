//
//  CardViewModel.swift
//  CardBox
//
//  Created by mactest on 13/03/2022.
//

import SwiftUI

class CardViewModel: ObservableObject {
    @Published var card: Card
    
    var imageName: String {
        AssetFetcher.getImageName(card: card)
    }
    var cardTitle: String {
        card.name
    }

    var cardDescription: String {
        card.cardDescription
    }
    
    init(card: Card) {
        self.card = card
    }
}
