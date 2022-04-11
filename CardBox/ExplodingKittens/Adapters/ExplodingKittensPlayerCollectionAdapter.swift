//
//  ExplodingKittensPlayerCollectionAdapter.swift
//  CardBox
//
//  Created by Stuart Long on 3/4/22.
//

class ExplodingKittensPlayerCollectionAdapter: PlayerCollectionAdapter, Codable {
    private var players: [ExplodingKittensPlayerAdapter]
    private var currentPlayerIndex: Int

    var playerCollection: PlayerCollection {
        var output: [Player] = []
        for player in players {
            output.append(player.gamePlayer)
        }
        return PlayerCollection(players: output, currentPlayerIndex: currentPlayerIndex)
    }

    var names: [String] {
        self.players.map { $0.name }
    }

    var count: Int {
        self.players.count
    }

    init(_ playerCollection: PlayerCollection) {
        self.players = []
        for player in playerCollection.getPlayers() {
            if let player = player as? ExplodingKittensPlayer {
                self.players.append(
                    ExplodingKittensPlayerAdapter(player))
            }
        }
        self.currentPlayerIndex = playerCollection.currentPlayerIndex
    }

    func getExplodingKittensPlayerAdapterByName(name: String) -> ExplodingKittensPlayerAdapter? {
        for player in players where player.name == name {
            return player
        }
        return nil
    }

    func remove(_ player: Player) {
        if let index = players.firstIndex(where: { $0.id == player.id }) {
            players.remove(at: index)
        }
    }

    func addPlayer(_ player: ExplodingKittensPlayer) {
        guard !players.contains(where: { $0.id == player.id }) else {
            return
        }

        self.players.append(ExplodingKittensPlayerAdapter(player))
    }

    func getPlayerByIndex(_ index: Int) -> ExplodingKittensPlayerAdapter? {
        guard index >= 0 && index < players.count else {
            return nil
        }

        return players[index]
    }
}
