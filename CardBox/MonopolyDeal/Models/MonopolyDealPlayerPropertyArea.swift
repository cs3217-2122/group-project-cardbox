//
//  MonopolyDealPlayerArea.swift
//  CardBox
//
//  Created by user213938 on 4/3/22.
//

class MonopolyDealPlayerPropertyArea: Codable {
    private var area: [CardCollection] = []

    var count: Int {
        area.count
    }

    func addCardCollection(_ cardCollection: CardCollection) {
        area.append(cardCollection)
    }

    func removeCardCollection(_ cardCollection: CardCollection) {
        guard let firstIndex = area.firstIndex(where: { $0 === cardCollection }) else {
            return
        }

        area.remove(at: firstIndex)
    }

    func getArea() -> [CardCollection] {
        area
    }

    func updateState(_ otherPlayerPropertyArea: MonopolyDealPlayerPropertyArea) {
        for index in 0..<count {
            self.area[index].updateState(otherPlayerPropertyArea.getArea()[index])
        }
    }
}
