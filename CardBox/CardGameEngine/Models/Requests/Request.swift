//
//  Request.swift
//  CardBox
//
//  Created by Bryann Yeap Kok Keong on 11/4/22.
//

import Foundation

class Request: Codable {
    var id = UUID()
    var description: String
    var fromPlayer: Player
    var toPlayer: Player
    var callback: Callback

    init(description: String, fromPlayer: Player, toPlayer: Player, callback: Callback) {
        self.description = description
        self.fromPlayer = fromPlayer
        self.toPlayer = toPlayer
        self.callback = callback
    }
}
