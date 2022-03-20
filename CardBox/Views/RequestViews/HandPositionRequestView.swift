//
//  HandPositionRequestView.swift
//  CardBox
//
//  Created by Stuart Long on 19/3/22.
//

import SwiftUI

struct HandPositionRequestView: View {
    @EnvironmentObject var gameRunnerViewModel: GameRunner
    @Binding var selectedPlayerViewModel: PlayerViewModel?

    var body: some View {
        if gameRunnerViewModel.isShowingPlayerHandPositionRequest {
            if let selectedPlayerViewModel = selectedPlayerViewModel {
                PositionRequestView(
                    dispatchPositionResponse: gameRunnerViewModel.dispatchPlayerHandPositionResponse,
                    toggleShowPositionRequestView: gameRunnerViewModel.togglePlayerHandPositionRequest,
                    size: selectedPlayerViewModel.player.hand.count
                )
            }
        }
    }
}

struct HandPositionRequest_Previews: PreviewProvider {
    static var previews: some View {
        HandPositionRequestView(selectedPlayerViewModel: .constant(nil))
    }
}
