//
//  CardRequestView.swift
//  CardBox
//
//  Created by Stuart Long on 19/3/22.
//

import SwiftUI

struct CardTypeRequestView: View {

    @State var selectedType = ""
    @Binding var cardTypeRequest: CardTypeRequest

    var overlay: some View {
        Rectangle()
            .background(Color.black)
            .opacity(0.5)
            .allowsHitTesting(true)
    }

    var messageBox: some View {
        VStack {
            ForEach(cardTypeRequest.cardTypes, id: \.self) { cardType in
                Button {
                    selectedType = cardType
                } label: {
                    Text(cardType)
                        .foregroundColor(selectedType == cardType
                                         ? Color.red : Color.black)
                }
            }
            Button {
                cardTypeRequest.executeCallback(value: selectedType)
                cardTypeRequest.hideRequest()
            } label: {
                Text("Submit")
            }
        }
        .contentShape(Rectangle())
        .padding(10)
        .background(Color.white)
    }

    var body: some View {
        EmptyView()
        if cardTypeRequest.isShowing {
            ZStack {
                overlay
                messageBox
            }
        }
    }
}
