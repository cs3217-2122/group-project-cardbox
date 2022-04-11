//
//  IntRequest.swift
//  CardBox
//
//  Created by Bryann Yeap Kok Keong on 11/4/22.
//

import Foundation

struct IntRequest {
    private(set) var id = UUID()
    private(set) var description: String // TODO: Add request description to view
    private(set) var fromPlayer: Player
    private(set) var toPlayer: Player
    private(set) var minValue: Int?
    private(set) var maxValue: Int?
    private(set) var callback: (Int) -> Void

    func createResponse(with value: Int) -> IntResponse {
        IntResponse(requestId: id, value: value)
    }
}
