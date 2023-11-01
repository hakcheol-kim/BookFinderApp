//
//  SplashView.swift
//  BookFinder
//
//  Created by 김학철 on 2023/10/31.
//

import SwiftUI

struct SplashView: View {
    @EnvironmentObject private var appState: AppStateVM
    @State private var chatactors: Array<String.Element> = Array("Book Finder")
    @State private var startAnimation = false
    var body: some View {
        ZStack {
            Color.main
                .ignoresSafeArea()
            
            
            HStack(spacing: 0) {
                ForEach(chatactors.indices, id: \.self) { i in
                    Text(String(chatactors[i]))
                        .foregroundColor(.white)
                        .font(.system(size: 34, weight: .semibold))
                        .opacity(startAnimation ? 1 : 0)
                        .animation(.easeOut.delay(Double(i) * 0.05), value: startAnimation)
                }
            }
        }
        .onAppear {
            startAnimation.toggle()
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
