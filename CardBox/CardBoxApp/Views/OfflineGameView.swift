//
//  OfflineGameViews.swift
//  CardBox
//
//  Created by user213938 on 4/18/22.
//

import SwiftUI

struct OfflineGameView: View {
    @State private var selectedGame: CardBoxGame?
    @State private var selected = false

    var ekButton: some View {
        Button(action: {
            selectedGame = .ExplodingKittens
        }) {
            Text("Exploding Kittens")
                .font(.system(size: 30))
                .frame(width: 200, height: 200)
                .padding()
                .overlay {
                    if selectedGame == .ExplodingKittens {
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.red, lineWidth: 10)
                    } else {
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.black, lineWidth: 4)
                    }
                }
        }
    }

    var mdButton: some View {
        Button(action: {
            selectedGame = .MonopolyDeal
        }) {
            Text("Monopoly Deal")
                .font(.system(size: 30))
                .frame(width: 200, height: 200)
                .padding()
                .overlay {
                    if selectedGame == .MonopolyDeal {
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.red, lineWidth: 10)
                    } else {
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.black, lineWidth: 4)
                    }
                }
        }
    }

    var goButton: some View {
        Button(action: {
            if let _ = selectedGame {
                selected = true
            }
        }) {
            Text("Go")
                .font(.system(size: 30))
        }
    }

    var body: some View {
        VStack(spacing: 20) {
            if !selected {
                Text("Please select a Game")
                    .font(.system(size: 50))
                HStack(spacing: 20) {
                    ekButton
                    mdButton
                }
                goButton
            } else if let selectedGame = selectedGame {
                switch selectedGame {
                case .ExplodingKittens:
                    ExplodingKittensOfflineView()
                case .MonopolyDeal:
                    MonopolyDealOfflineView()
                }
            }
        }
    }
}
