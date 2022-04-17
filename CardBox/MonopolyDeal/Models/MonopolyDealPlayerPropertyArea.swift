//
//  MonopolyDealPlayerArea.swift
//  CardBox
//
//  Created by user213938 on 4/3/22.
//

class MonopolyDealPlayerPropertyArea: Codable {
    private var area: [MonopolyDealPropertySet] = []

    var count: Int {
        area.count
    }

    func addCardCollection(_ cardCollection: MonopolyDealPropertySet) {
        area.append(cardCollection)
        area = area.filter { !$0.isEmpty }
    }

    func removeCardCollection(_ cardCollection: CardCollection) {
        guard let firstIndex = area.firstIndex(where: { $0 === cardCollection }) else {
            return
        }

        area.remove(at: firstIndex)
    }

    func getArea() -> [MonopolyDealPropertySet] {
        area
    }

    func canAdd(_ card: Card) -> Bool {
        card is PropertyCard
    }

    func addPropertyCard(_ card: PropertyCard) {
        addCardCollection(MonopolyDealPropertySet(cards: [card], setColour: card.colors.first ?? .red))
    }

    static func getFirstStandardPropertyCardFromSet(_ propertySet: CardCollection) -> PropertyCard? {
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

    static func getFirstPropertyCardFromSet(_ propertySet: CardCollection) -> PropertyCard? {
        guard let propertyCard = propertySet.getCards().first(where: { $0 is PropertyCard }) as? PropertyCard else {
            return nil
        }
        return propertyCard
    }

    func getFirstPropertySetOfColor(_ color: PropertyColor) -> MonopolyDealPropertySet? {
        for propertySet in area {
            guard let propertyCard = MonopolyDealPlayerPropertyArea
                    .getFirstPropertyCardFromSet(propertySet) else {
                        return nil
                    }

            if propertyCard.colors.contains(color) {
                return propertySet
            }
        }
        return nil
    }

    func updateState(_ otherPlayerPropertyArea: MonopolyDealPlayerPropertyArea) {
        self.area = otherPlayerPropertyArea.getArea()
    }

    func getPropertySet(from card: Card) -> MonopolyDealPropertySet? {
        for propertySet in area {
            if propertySet.containsCard(card) {
                return propertySet
            }
        }
        return nil
    }

    var numberOfFullSets: Int {
        getListOfFullSets().count
    }

    func getListOfFullSets() -> [MonopolyDealPropertySet] {
        area.filter { $0.isFullSet }
    }
}
