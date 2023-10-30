//
//  BookFinderAppApp.swift
//  BookFinderApp
//
//  Created by 김학철 on 2023/10/31.
//

import SwiftUI

@main
struct BookFinderAppApp: App {
    @StateObject var appState = AppStateVM()
    
    var body: some Scene {
        WindowGroup {
            if appState.screenType == .splish {
                SplashView()
                    .environmentObject(appState)
            }
            else {
                MainView()
                    .environmentObject(appState)
                    .overlay {
                        if appState.showLoadingView {
                            SpinerView()
                        }
                    }
            }
        }
    }
}
