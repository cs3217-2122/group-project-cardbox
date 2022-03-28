//
//  CardBoxApp.swift
//  CardBox
//
//  Created by mactest on 10/03/2022.
//

import SwiftUI
import Firebase

@main
struct CardBoxApp: App {
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
