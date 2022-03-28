//
//  CardRequestView.swift
//  CardBox
//
//  Created by Stuart Long on 19/3/22.
//

import SwiftUI

struct CardTypeRequestView: View {
    @EnvironmentObject var gameRunnerViewModel: ExplodingKittensGameRunner
    @State var selectedType = ""
    private var dispatchCardTypeResponse: (String) -> Void
    private var toggleCardTypeRequestView: (Bool) -> Void

    init(dispatchCardTypeResponse: @escaping (String) -> Void,
         toggleCardTypeRequestView: @escaping (Bool) -> Void) {
        self.dispatchCardTypeResponse = dispatchCardTypeResponse
        self.toggleCardTypeRequestView = toggleCardTypeRequestView
    }

    var overlay: some View {
        Rectangle()
            .background(Color.black)
            .opacity(0.5)
            .allowsHitTesting(true)
    }

    var messageBox: some View {
        VStack {
            ForEach(gameRunnerViewModel.allCardTypes, id: \.self) { cardType in
                Button {
                    selectedType = cardType.rawValue
                } label: {
                    Text(cardType.rawValue)
                        .foregroundColor(selectedType == cardType.rawValue
                                         ? Color.red : Color.black)
                }
            }
            Button {
                dispatchCardTypeResponse(selectedType)
                toggleCardTypeRequestView(false)
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
//        if gameRunnerViewModel.isShowingCardTypeRequest {
//            ZStack {
//                overlay
//                messageBox
//            }
//        }
    }
}
