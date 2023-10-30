//
//  UIApplication+Extension.swift
//  BookFinderApp
//
//  Created by 김학철 on 2023/10/31.
//

import SwiftUI
extension UIApplication {
    func topViewController() -> UIViewController? {
        var topViewController: UIViewController? = nil
        for scene in connectedScenes {
            if let windowScene = scene as? UIWindowScene {
                for window in windowScene.windows {
                    if window.isKeyWindow {
                        topViewController = window.rootViewController
                    }
                }
            }
        }
        
        while true {
            if let presented = topViewController?.presentedViewController {
                topViewController = presented
            }
            else if let navController = topViewController as? UINavigationController {
                topViewController = navController.topViewController
            }
            else if let tabBarController = topViewController as? UITabBarController {
                topViewController = tabBarController.selectedViewController
            } else {
                // Handle any other third party container in `else if` if required
                break
            }
        }
        return topViewController
    }
}
