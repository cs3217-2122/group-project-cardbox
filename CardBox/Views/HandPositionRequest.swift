//
//  HandPositionRequest.swift
//  CardBox
//
//  Created by Stuart Long on 19/3/22.
//

import SwiftUI

struct HandPositionRequest: View {
    @EnvironmentObject var gameRunnerViewModel: GameRunner
    @Binding var selectedPlayerViewModel: PlayerViewModel?

    var body: some View {
        if gameRunnerViewModel.isShowingPlayerHandPositionRequest {
            if let selectedPlayerViewModel = selectedPlayerViewModel {
                // for favour and 2 of a kind
                // the main difference is that for favour, the owner of the hand can choose an index to give,
                // while for 2 of a kind, the player who plays it can choose an index.
                (PositionRequestView(dispatchPositionResponse:
                                        gameRunnerViewModel.dispatchPlayerHandPositionResponse,
                                     toggleShowPositionRequestView:
                                        gameRunnerViewModel.togglePlayerHandPositionRequest,
                                     size: selectedPlayerViewModel.player.hand.getSize()))
            }
        }
    }
}

struct HandPositionRequest_Previews: PreviewProvider {
    static var previews: some View {
        HandPositionRequest(selectedPlayerViewModel: .constant(nil))
    }
}
