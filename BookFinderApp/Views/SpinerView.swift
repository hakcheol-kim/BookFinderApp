//
//  SpinerView.swift
//  BookFinderApp
//
//  Created by 김학철 on 2023/10/31.
//

import SwiftUI

struct SpinerView: View {
    var body: some View {
        ZStack {
            Color.clear.ignoresSafeArea(.all)
            
            ProgressView()
                .progressViewStyle(.circular)
                .frame(width: 40, height: 40)
                .tint(.main)
                .edgesIgnoringSafeArea(.all)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .disabled(true)
    }
}

#Preview {
    SpinerView()
}
