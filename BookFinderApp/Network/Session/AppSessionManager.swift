//
//  AppSessionManager.swift
//  BookFinder
//
//  Created by 김학철 on 2023/10/31.
//

import Foundation
import Alamofire

final class AppSessionManager {
    static let `default` = AppSessionManager()
    
    var session: Session
    init() {
        #if DEBUG
        let monitors = [ApiLogger(logoLevels: [.all])] as [EventMonitor]
        self.session = Session(eventMonitors: monitors)
        #else
        self.session = Session()
        #endif
    }
}
