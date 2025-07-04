//
//  App.swift
//  App
//
//  Created by akiho on 2025/07/01.
//

import Feature
import SwiftUI

@main
struct MyApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
