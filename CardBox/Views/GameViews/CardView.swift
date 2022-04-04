//
//  CardView.swift
//  CardBox
//
//  Created by mactest on 13/03/2022.
//

import SwiftUI

struct CardView: View {
    @EnvironmentObject private var gameRunnerViewModel: ExplodingKittensGameRunner
    @ObservedObject var viewModel: CardViewModel
    var currentPlayerViewModel: PlayerViewModel
    var isFaceUp: Bool
    static let defaultCardWidth = 150
    let cardWidth = CGFloat(150)
    let cardHeight = CGFloat(250)

    init(cardViewModel: CardViewModel, currentPlayerViewModel: PlayerViewModel) {
        self.viewModel = cardViewModel
        self.isFaceUp = cardViewModel.isFaceUp
        self.currentPlayerViewModel = currentPlayerViewModel
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

    var viewFrame: some View {
        buildView()
            .padding()
            .aspectRatio(0.5, contentMode: .fill)
            .frame(width: cardWidth, height: cardHeight)
            .background(Color.white)
            .border(Color.black)
            .offset(y: viewModel.isSelected ? -35: 0)
    }

    var body: some View {
        if let card = viewModel.card,
            currentPlayerViewModel.isCurrentPlayer(gameRunner: gameRunnerViewModel) {
            viewFrame
                .onDrag {
                    gameRunnerViewModel.cardsDragging = [card]
                    return NSItemProvider(object: card.name as NSString)
                }
        } else {
            viewFrame
        }
    }
}
