//
//  SplashView.swift
//  BookFinder
//
//  Created by 김학철 on 2023/10/31.
//

import SwiftUI

struct SplashView: View {
    @EnvironmentObject private var appState: AppStateVM
    var body: some View {
        ZStack {
            Color.main
                .ignoresSafeArea()
            
            Text("Book Finder App")
                .foregroundColor(.white)
                .font(.custom(.largeTitle))
            
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                appState.screenType = .main
            }
        }
    }
}

#Preview {
    SplashView()
        .environmentObject(AppStateVM())
}
