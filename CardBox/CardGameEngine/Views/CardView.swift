//
//  CardView.swift
//  CardBox
//
//  Created by mactest on 13/03/2022.
//

import SwiftUI

struct CardView: View {
    @EnvironmentObject private var gameRunnerDelegate: GameRunnerDelegate
    var gameRunnerViewModel: GameRunnerProtocol {
        gameRunnerDelegate.runner
    }

    @ObservedObject var viewModel: CardViewModel
    var bottomPlayer: Player?
    var bottomPlayerViewModel: PlayerViewModel?
    var playerViewModel: PlayerViewModel?
    var isFaceUp: Bool
    static let defaultCardWidth = 150
    let cardWidth = CGFloat(150)
    let cardHeight = CGFloat(250)

    init(card: Card?, isFaceUp: Bool, isSelected: Bool) {
        viewModel = CardViewModel(
            card: card,
            isFaceUp: isFaceUp,
            isSelected: isSelected
        )

        self.isFaceUp = isFaceUp
    }

    init(card: Card?, isFaceUp: Bool, isSelected: Bool, bottomPlayer: Player) {
        viewModel = CardViewModel(
            card: card,
            isFaceUp: isFaceUp,
            isSelected: isSelected
        )

        self.isFaceUp = isFaceUp
        bottomPlayerViewModel = PlayerViewModel(
            player: bottomPlayer,
            hand: CardCollection()
        )
        self.bottomPlayer = bottomPlayer
    }

    // init(cardViewModel: CardViewModel, currentPlayerViewModel: PlayerViewModel) {
    //    self.viewModel = cardViewModel
    //    self.isFaceUp = cardViewModel.isFaceUp
    //    self.bottomPlayerViewModel = currentPlayerViewModel
    // }

    // init(cardViewModel: CardViewModel, currentPlayerViewModel: PlayerViewModel, playerViewModel: PlayerViewModel) {
    //    self.viewModel = cardViewModel
    //    self.isFaceUp = cardViewModel.isFaceUp
    //    self.bottomPlayerViewModel = currentPlayerViewModel
    //    self.playerViewModel = playerViewModel
    // }

    var canInteract: Bool {
        if let playerViewModel = playerViewModel, let bottomPlayerViewModel = bottomPlayerViewModel {
            return bottomPlayerViewModel.player.id == playerViewModel.player.id
            && bottomPlayerViewModel.isCurrentPlayer(gameRunner: gameRunnerViewModel)
        } else {
            return false
        }
    }

    var buildView: some View {
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
        buildView
            .padding()
            .aspectRatio(0.5, contentMode: .fill)
            .frame(width: cardWidth, height: cardHeight)
            .background(Color.white)
            .border(Color.black)
            .offset(y: viewModel.isSelected ? -35: 0)
            .onAppear {
                if let bottomPlayer = bottomPlayer {
                    bottomPlayerViewModel?.setHand(hand: gameRunnerViewModel.getHandByPlayer(bottomPlayer)
                                                   ?? CardCollection())
                }
            }
    }

    var body: some View {
        if let card = viewModel.card,
           // offline: can drag current player cards
           // online: local player can drag local player cards (if local player is current player)
            canInteract {
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
