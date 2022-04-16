//
//  Message.swift
//  CardBox
//
//  Created by user213938 on 4/17/22.
//

enum MessageType {
    case error
    case success
    case information
}

struct Message: Equatable {
    let title: String
    let description: String
    let type: MessageType
}
