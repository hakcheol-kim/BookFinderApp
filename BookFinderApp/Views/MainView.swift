//
//  MainView.swift
//  BookFinder
//
//  Created by 김학철 on 2023/10/30.
//

import SwiftUI
import SFSafeSymbols
import Combine

extension MainView {
    enum FocusField: Hashable {
        case searchField
    }
}
struct MainView: View {
    @EnvironmentObject private var appState: AppStateVM
    @StateObject private var vm = MainView.ViewModel()
    @State private var isScrollTop: Bool = true
    @FocusState private var focus: MainView.FocusField?
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.primary10
                    .ignoresSafeArea()
                
                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0, alignment: .center), count: vm.isListType ? 1 : 2),
                              spacing: 0, pinnedViews: [.sectionHeaders])
                    {
                        Section {
                            if !vm.listData.isEmpty {
                                ForEach(Array(zip(vm.listData.indices, vm.listData)), id: \.0) { index, item in
                                    NavigationLink {
                                        BookDetailView(item: item)
                                            .environmentObject(appState)
                                    } label: {
                                        MainListCell(isListType: $vm.isListType, item: item)
                                            .onAppear {
                                                vm.ifNeedMoreItem(index)
                                            }
                                    }
                                }
                            }
                            else {
                                noListView
                            }
                        } header: {
                            headerView
                        }
                    }
                    .overlay {
                        GeometryReader { geo in
                            let offset = geo.frame(in: .named("scrollOffsetY")).minY
                            Color.clear.preference(key: ScrollPreferenceKey.self, value: offset)
                        }
                    }
                }
            }
            .onChange(of: vm.isLoading) { newValue in
                appState.showLoadingView = newValue
            }
            .coordinateSpace(name: "scrollOffsetY")
            .onPreferenceChange(ScrollPreferenceKey.self) { value in
                self.isScrollTop = value < -20
                focus = nil
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
            .navigationApparance(bgColor: .primary10, fgColor: .primary100)
            .navigationBarTitleDisplayMode(.large)
            .navigationTitle("Book Finder")
            .onAppear {
                
            }
        }
    }
    
    //ComponetView
    var noListView: some View {
        VStack {
            Spacer(minLength: 150)
            Text("검색 결과가 없습니다.")
                .font(.custom(.body3))
                .foregroundColor(.primary30)
            Spacer()
        }
    }
   
    var searchBarView: some View {
        TextField("검색어를 입력해주세요.", text: $vm.searchTxt)
            .onChange(of: vm.searchTxt) { newValue in
                vm.delayFetch()
            }
            .focused($focus, equals: .searchField)
            .padding(.leading, 32)
            .padding(.trailing, 16)
            .padding(.vertical, 8)
            .keyboardType(.default)
            .submitLabel(.search)
            .onSubmit {
                focus = nil
                vm.dataReset()
            }
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .foregroundColor(.primary20)
            )
            .overlay {
                HStack {
                    Image(systemSymbol: .magnifyingglass)
                        .font(.custom(.h3))
                        .foregroundColor(.main)
                    
                    Spacer()
                }
                .padding(.horizontal, 8)
            }
            .padding(.vertical, 8)
    }
    
    var headerView: some View {
        VStack(spacing: 0) {
            searchBarView
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
            
            HStack {
                let attr : AttributedString = {
                    let countStr = vm.totalCount.addComma()
                    let result = "전체 : \(countStr)"
                    var attr = AttributedString(result)
                    attr.font = Font.system(size: 13, weight: .regular)
                    attr.foregroundColor = .primary90
                    let range = attr.range(of: countStr)!
                    attr[range].foregroundColor = Color.main
                    attr[range].font = Font.system(size: 13, weight: .semibold)
                    return attr
                }()
                
                Text(attr)
                    .padding(.leading, 16)
                
                Spacer()
                
                Button {
                    withAnimation {
                        vm.isListType.toggle()
                    }
                } label: {
                    Image(systemSymbol: vm.isListType ? .listBullet : .squareGrid2x2)
                        .font(.custom(.body1))
                        .foregroundColor(.main)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                }
            }
            
            if isScrollTop {
                Divider()
            }
        }
        .background {
            Color.primary10
        }
    }
}

#Preview {
    MainView()
        .environmentObject(AppStateVM())
}

extension MainView {
    class ViewModel: NSObject, ObservableObject {
        private var cancelBag = Set<AnyCancellable>()
        @Published var searchTxt = ""
        @Published var listData: [BookModel] = []
        @Published var isLoading = false
        @Published var totalCount = 0
        @Published var isListType = true
        
        private var startIndex = 0
        private var maxResults = 20
        private var isPageEnd = false
        
        override init() {
            super.init()
            searchTxt = "flower"
            dataReset()
        }
        
        func delayFetch() {
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(dataReset), object: nil)
            perform(#selector(dataReset), with: nil, afterDelay: 0.5)
        }
        
        @objc func dataReset() {
            isPageEnd = false
            startIndex = 0
            requestBooks()
        }
        func ifNeedMoreItem(_ index: Int) {
            if isPageEnd {
                return
            }
            if index == listData.count - 1 {
                addData()
            }
        }
        func addData() {
            requestBooks()
        }
        
        private func requestBooks() {
            var param = [String : Any]()
            param["q"] = searchTxt
            param["startIndex"] = startIndex
            param["maxResults"] = maxResults
            
            if isPageEnd {
                return
            }
            
            self.isLoading = true
            ApiService.request(.searchBooks(param), decoder: BookResModel.self)
                .sink { res in
                    self.isLoading = false
                    switch res {
                    case .finished:
                        break
                    case .failure(let error):
                        self.isPageEnd = true
                        self.listData = []
                        self.totalCount = 0
                        print(error)
                        break
                    }
                } receiveValue: { resModel in
                    self.isLoading = false
                    print(resModel.items.count)
                    debugPrint(resModel)
                    
                    if self.startIndex == 0 {
                        self.totalCount = resModel.totalItems
                        self.listData = resModel.items
                    }
                    else if resModel.items.count > 0 {
                        self.listData.append(contentsOf: resModel.items)
                    }
                    self.startIndex += self.maxResults
                    if self.startIndex > self.totalCount || resModel.items.count == 0 {
                        self.isPageEnd = true
                    }
                }
                .store(in: &cancelBag)
        }

    }
}
