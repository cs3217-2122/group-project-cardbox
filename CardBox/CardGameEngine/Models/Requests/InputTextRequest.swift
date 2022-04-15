//
//  InputTextRequest.swift
//  CardBox
//
//  Created by Bryann Yeap Kok Keong on 14/4/22.
//

import Foundation

class InputTextRequest: Request {
    override init(description: String,
                  fromPlayer: Player,
                  toPlayer: Player,
                  callback: Callback) {
        super.init(description: description, fromPlayer: fromPlayer, toPlayer: toPlayer, callback: callback)
    }

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
}
