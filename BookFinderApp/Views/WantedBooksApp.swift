//
//  BookFinderApp.swift
//  BookFinder
//
//  Created by 김학철 on 2023/10/30.
//

import SwiftUI

@main
struct BookFinderApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject var appState = AppStateVM()
    
    var body: some Scene {
        WindowGroup {
            if appState.screenType == .splish {
                SplashView()
                    .environmentObject(appState)
            }
            else {
                MainView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    .environmentObject(appState)
            }
        }
    }
}
