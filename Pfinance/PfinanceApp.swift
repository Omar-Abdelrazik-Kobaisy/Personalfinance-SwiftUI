//
//  PfinanceApp.swift
//  Pfinance
//
//  Created by Omar on 09/03/2024.
//

import SwiftUI

@main
struct PfinanceApp: App {
    private let persistenceController = PersistenceController.shared
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
