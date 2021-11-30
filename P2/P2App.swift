//
//  P2App.swift
//  P2
//
//  Created by Noah Wilder on 2021-11-09.
//

import SwiftUI
import Firebase
import UserNotifications

@main
struct P2App: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
