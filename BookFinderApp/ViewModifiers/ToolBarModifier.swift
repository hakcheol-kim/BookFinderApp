//
//  ToolBarModifier.swift
//  BookFinder
//
//  Created by 김학철 on 2023/10/31.
//

import SwiftUI

extension UINavigationController: UIGestureRecognizerDelegate {
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}

struct NaviToolBarModifier: ViewModifier {
    
    init(bgColor: Color, fgColor: Color) {
        let backgroundColor = UIColor(bgColor)
        let forgroundColor = UIColor(fgColor)
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = backgroundColor
        appearance.configureWithOpaqueBackground()
        appearance.titleTextAttributes = [.foregroundColor : forgroundColor, .font : UIFont.systemFont(ofSize: 16, weight: .semibold)]
        appearance.largeTitleTextAttributes = [.foregroundColor : forgroundColor, .font : UIFont.systemFont(ofSize: 22, weight: .bold)]
        
        let appearanceS = appearance
        appearanceS.shadowColor = .clear
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearanceS
        
        UINavigationBar.appearance().isTranslucent = true
        
    }
    func body(content: Content) -> some View {
        content
    }
}
extension View {
    func navigationApparance(bgColor: Color, fgColor: Color) -> some View {
        self.modifier(NaviToolBarModifier(bgColor: bgColor, fgColor: fgColor))
    }
    
   
}
