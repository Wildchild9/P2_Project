//
//  P2App.swift
//  P2
//
//  Created by Noah Wilder on 2021-11-09.
//

import SwiftUI
import Firebase

@main
struct P2App: App {
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
