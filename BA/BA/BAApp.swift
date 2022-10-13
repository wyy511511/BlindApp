//
//  BAApp.swift
//  BA
//
//  Created by 511 on 2021/8/10.
//

import SwiftUI

@main
struct BAApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
