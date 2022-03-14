//
//  CardView.swift
//  CardBox
//
//  Created by mactest on 13/03/2022.
//

import SwiftUI

struct CardView: View {
    let viewModel: CardViewModel
    
    

    init(card: Card) {
        self.viewModel = CardViewModel(card: card)
    }
    

    var body: some View {
        VStack{
            Image(viewModel.imageName)
                .resizable()
                .scaledToFit()

                .aspectRatio(2.0, contentMode: .fill)
                .frame(maxWidth: 100, maxHeight: 100)
                .border(.black)
                
            Text(viewModel.cardTitle)
            Text(viewModel.cardDescription)
                .font(.caption)
        }
        .padding()
        .aspectRatio(0.5, contentMode: .fill)
        .frame(maxWidth: 150, maxHeight: 300)

        .background(Color.white)
        .border(.black)
    }
}

struct Card_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card: Card(name: "Bomb"))
    }
}
