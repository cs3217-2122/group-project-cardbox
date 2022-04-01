//
//  PlayerCollectionAdapter.swift
//  CardBox
//
//  Created by Stuart Long on 2/4/22.
//

class PlayerCollectionAdapter: Codable {
    private var players: [PlayerAdapter]

    var names: [String] {
        self.players.map { $0.name }
    }

    var count: Int {
        self.players.count
    }

    init(_ playerCollection: PlayerCollection) {
        self.players = []
        for player in playerCollection.getPlayers() {
            self.players.append(PlayerAdapter(player))
        }
    }

    func remove(_ player: Player) {
        if let index = players.firstIndex(where: { $0.id == player.id }) {
            players.remove(at: index)
        }
        for player in players {
            print(player.name)
        }
    }

    func addPlayer(_ player: Player) {
        guard !players.contains(where: { $0.id == player.id }) else {
            return
        }

        self.players.append(PlayerAdapter(player))
    }

    func getPlayerByIndex(_ index: Int) -> PlayerAdapter? {
        guard index >= 0 && index < players.count else {
            return nil
        }

        return players[index]
    }
}
