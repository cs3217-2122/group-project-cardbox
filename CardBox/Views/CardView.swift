//
//  CardView.swift
//  CardBox
//
//  Created by mactest on 13/03/2022.
//

import SwiftUI

struct CardView: View {
    let viewModel: CardViewModel
    var isFaceUp = true

    init(card: Card) {
        self.viewModel = CardViewModel(card: card)
    }

    init(card: Card, isFaceUp: Bool) {
        self.viewModel = CardViewModel(card: card)
        self.isFaceUp = isFaceUp
    }

    var body: some View {
        VStack {
            Image(viewModel.imageName)
                .resizable()
                .scaledToFit()
                .aspectRatio(2.0, contentMode: .fill)
                .frame(maxWidth: 100, maxHeight: 100)
                .border(.black)
                .padding(.top)
            Text(viewModel.cardTitle)
                .fontWeight(.bold)
            Text(viewModel.cardDescription)
                .font(.caption)
            Spacer()
        }
        .padding()
        .aspectRatio(0.5, contentMode: .fill)
        .frame(maxWidth: 150, maxHeight: 250)
        .background(Color.white)
        .border(.black)
    }
}

struct Card_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card: Card(name: "Bomb"))
    }
}
