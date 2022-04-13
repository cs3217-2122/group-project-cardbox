//
//  IntRequest.swift
//  CardBox
//
//  Created by Bryann Yeap Kok Keong on 11/4/22.
//

import Foundation

struct IntRequest: Request {
    private(set) var id = UUID()
    private(set) var description: String
    private(set) var fromPlayer: Player
    private(set) var toPlayer: Player
    private(set) var minValue: Int?
    private(set) var maxValue: Int?
    private(set) var callback: (Response) -> Void
}
