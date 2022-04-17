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
        area = area.filter { !$0.isEmpty }
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

    func canAdd(_ card: Card) -> Bool {
        card is PropertyCard
    }

    func addPropertyCard(_ card: PropertyCard) {
        addCardCollection(MonopolyDealPropertySet(cards: [card], setColour: card.colors.first ?? .red))
    }

    func getFirstStandardPropertyCardFromSet(_ propertySet: CardCollection) -> PropertyCard? {
        guard let propertyCard = propertySet.getCards().first(where: {
            guard let standardPropertyCard = $0 as? PropertyCard else {
                return false
            }
            return standardPropertyCard.colors.count == 1
        }) as? PropertyCard else {
            return nil
        }
        return propertyCard
    }

    func getFirstPropertyCardFromSet(_ propertySet: CardCollection) -> PropertyCard? {
        guard let propertyCard = propertySet.getCards().first(where: { $0 is PropertyCard }) as? PropertyCard else {
            return nil
        }
        return propertyCard
    }

    func updateState(_ otherPlayerPropertyArea: MonopolyDealPlayerPropertyArea) {
        for index in 0..<count {
            self.area[index].updateState(otherPlayerPropertyArea.getArea()[index])
        }
    }

    func getPropertySet(from card: Card) -> CardCollection? {
        for propertySet in area {
            if propertySet.containsCard(card) {
                return propertySet
            }
        }
        return nil
    }
}
