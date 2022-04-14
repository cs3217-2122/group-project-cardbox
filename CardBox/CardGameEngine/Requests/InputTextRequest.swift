//
//  InputTextRequest.swift
//  CardBox
//
//  Created by Bryann Yeap Kok Keong on 14/4/22.
//

import Foundation

struct InputTextRequest: Request {
    private(set) var id = UUID()
    private(set) var description: String
    private(set) var fromPlayer: Player
    private(set) var toPlayer: Player
    private(set) var callback: (Response) -> Void
    private(set) var isValidInput: (String) -> Bool
}
