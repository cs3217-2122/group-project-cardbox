//
//  Request.swift
//  CardBox
//
//  Created by Bryann Yeap Kok Keong on 11/4/22.
//

import Foundation

protocol Request {
    var id: UUID { get }
    var description: String { get }
    var fromPlayer: Player { get }
    var toPlayer: Player { get }
    var callback: (Response) -> Void { get }
}
