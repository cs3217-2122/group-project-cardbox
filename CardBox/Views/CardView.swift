//
//  CardView.swift
//  CardBox
//
//  Created by mactest on 13/03/2022.
//

import SwiftUI

struct CardView: View {
    @ObservedObject var viewModel: CardViewModel
    var isFaceUp: Bool
    static let defaultCardWidth = 150
    let cardWidth = CGFloat(150)
    let cardHeight = CGFloat(250)

    init(cardViewModel: CardViewModel) {
        self.viewModel = cardViewModel
        self.isFaceUp = cardViewModel.isFaceUp
    }

    func buildView() -> AnyView {
        if let card = viewModel.card {
            guard let imageName = viewModel.imageName else {
                return AnyView(
                    Text("No card in stack")
                        .fontWeight(.bold)
                )
            }
            if isFaceUp {
                return AnyView(
                    VStack {
                        Image(imageName)
                            .resizable()
                            .scaledToFit()
                            .aspectRatio(2.0, contentMode: .fill)
                            .frame(maxWidth: 100, maxHeight: 100)
                            .border(Color.black)
                            .padding(.top)
                        Text(card.name)
                            .fontWeight(.bold)
                        Text(card.cardDescription)
                            .font(.caption)
                        Spacer()
                    })
            } else {
                return AnyView(Text("Back of card"))
            }
        } else {
            return AnyView(
                Text("No card in stack")
                    .fontWeight(.bold)
            )
        }
    }

    var body: some View {
        buildView()
            .padding()
            .aspectRatio(0.5, contentMode: .fill)
            .frame(width: cardWidth, height: cardHeight)
            .background(Color.white)
            .border(Color.black)
            .offset(y: viewModel.isSelected ? -50: 0)
    }
}

struct Card_Previews: PreviewProvider {
    static var previews: some View {
        CardView(cardViewModel: CardViewModel(card: Card(name: "Bomb")))
    }
}
