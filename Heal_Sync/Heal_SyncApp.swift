//
//  Heal_SyncApp.swift
//  Heal_Sync
//
//  Created by iPHTech 30 on 18/09/26.
//

import SwiftUI
import CoreData

@main
struct Heal_SyncApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
