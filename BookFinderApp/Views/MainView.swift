//
//  MainView.swift
//  BookFinder
//
//  Created by 김학철 on 2023/10/30.
//

import SwiftUI
import SFSafeSymbols
import Combine


struct MainView: View {
    @EnvironmentObject private var appState: AppStateVM
    @StateObject private var vm = MainView.ViewModel()

    var body: some View {
        NavigationView {
            ZStack {
                Color.primary10
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    searchBar
                    
                    Spacer()
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        
                    } label: {
                        Image(systemSymbol: .manatsignCircle)
                    }
                }
            }
            .navigationApparance(bgColor: .primary10, fgColor: .primary100)
            .navigationBarTitleDisplayMode(.large)
            .navigationTitle("Book Finder App")
        }
        
        
    }
    
  
}

extension MainView {
    var searchBar: some View {
        TextField("검색어를 입력해주세요.", text: $vm.searchTxt)
            .padding(.leading, 32)
            .padding(.trailing, 16)
            .padding(.vertical, 8)
            .keyboardType(.default)
            .submitLabel(.search)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .foregroundColor(.primary20)
            )
            .overlay {
                HStack {
                    Image(systemSymbol: .magnifyingglass)
                        .font(.custom(.h3))
                        .foregroundColor(.primary60)
                    
                    Spacer()
                }
                .padding(.horizontal, 8)
            }
            .padding(16)
    }
}
#Preview {
    MainView()
        .environmentObject(AppStateVM())
}

extension MainView {
    class ViewModel: ObservableObject {
        private var cancelBag = Set<AnyCancellable>()
        @Published var searchTxt = ""
        
    }
}
