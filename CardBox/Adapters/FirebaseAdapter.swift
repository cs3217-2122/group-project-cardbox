//
//  FirebaseAdapter.swift
//  CardBox
//
//  Created by Stuart Long on 1/4/22.
//

protocol FirebaseAdapter: Codable {
    var isWin: Bool { get set }
    var winner: String { get set }
//    var players: PlayerCollectionAdapter { get set }
}
