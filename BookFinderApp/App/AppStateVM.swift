//
//  AppStateVM.swift
//  BookFinder
//
//  Created by 김학철 on 2023/10/31.
//

import SwiftUI
import Combine
enum ScreenType {
    case splish, main
}

class AppStateVM: ObservableObject {
    @Published var screenType: ScreenType = .splish
}

