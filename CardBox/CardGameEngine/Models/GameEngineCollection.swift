//
//  GameEngineCollection.swift
//  CardBox
//
//  Created by user213938 on 4/16/22.
//

class GameEngineCollection<T: Codable>: Identifiable, Codable {
    private var collection: [T]

    init(_ collection: [T]) {
        self.collection = collection
    }

    convenience init() {
        self.init([])
    }

    var first: T? {
        collection.first
    }

    func first(where predicate: (T) -> Bool) -> T? {
        collection.first(where: predicate)
    }

    func append(_ item: T) {
        collection.append(item)
    }

    func removeAll(where predicate: (T) -> Bool) {
        collection.removeAll(where: predicate)
    }

    func getCollection() -> [T] {
        collection
    }

    func updateState(_ collection: GameEngineCollection<T>) {
        self.collection = collection.collection
    }
}
