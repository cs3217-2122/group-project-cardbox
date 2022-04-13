//
//  Response.swift
//  CardBox
//
//  Created by Bryann Yeap Kok Keong on 11/4/22.
//

import Foundation

protocol Response {
    var id: UUID { get }
    var requestId: UUID { get }
}
