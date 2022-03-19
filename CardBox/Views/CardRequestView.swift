//
//  CardRequestView.swift
//  CardBox
//
//  Created by Stuart Long on 19/3/22.
//

import SwiftUI

struct CardRequestView: View {
    @EnvironmentObject var gameRunnerViewModel: GameRunner

    var overlay: some View {
        Rectangle()
            .background(Color.black)
            .opacity(0.5)
            .allowsHitTesting(true)
    }

    var messageBox: some View {
        VStack {
            HStack {
            }
            Button(action: {

            }) {
                Text("Submit")
            }
        }
        .contentShape(Rectangle())
        .padding(10)
        .background(Color.white)
    }

    var body: some View {
        ZStack {
            overlay
            messageBox
        }
    }
}

struct CardRequestView_Previews: PreviewProvider {
    static var previews: some View {
        CardRequestView()
    }
}
