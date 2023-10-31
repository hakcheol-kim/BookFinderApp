//
//  ApiLogger.swift
//  BookFinder
//
//  Created by 김학철 on 2023/10/31.
//

import Foundation
import Alamofire
enum LogLevel: CaseIterable {
    case none, url, method, header, body, statuscode, response, errorresponse, all
}

final class ApiLogger: EventMonitor {
    let logoLevels: [LogLevel]
    
    init(logoLevels: [LogLevel]) {
        self.logoLevels = logoLevels
    }
    
    let queue: DispatchQueue = DispatchQueue(label: "Toggle_ApiLogger")
    
    func requestDidFinish(_ request: Request) {
        logoLevels.forEach { level in
            if level == .url || level == .all {
                print("-----------------  🛰 NETWORK Reqeust LOG -----------------")
                print("URL: \((request.request?.url?.absoluteString ?? ""))")
            }
            
            if level == .method || level == .all {
                print("Method: " + (request.request?.httpMethod ?? ""))
            }
            
            if level == .header || level == .all {
                print("Headers: " + "\(request.request?.allHTTPHeaderFields ?? [:])")
            }
            
            if level == .body || level == .all {
                if let body = request.request?.httpBody?.toPrettyPrintedString {
                    print("Body: " + "\(body)")
                }
            }
        }
    }
    
    func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
        logoLevels.forEach { level in
            if level == .statuscode || level == .all {
                print("StatusCode: " + "\(response.response?.statusCode ?? -9999)")
            }
            
            if level == .response || level == .all {
                if let response = response.data?.toPrettyPrintedString {
                    print("Response: " + response)
                }
            }
            else if level == .errorresponse && !(200..<300).contains(Int(response.response?.statusCode ?? 0)) {
                if let response = response.data?.toPrettyPrintedString {
                    print("Response: " + response)
                }
            }
        }
    }
    
    func request(_ request: Request, didFailTask task: URLSessionTask, earlyWithError error: AFError) {
        print("URLSessionTask가 Fail 했습니다.")
    }
    
    func request(_ request: Request, didFailToCreateURLRequestWithError error: AFError) {
        print("URLRequest를 만들지 못했습니다.")
    }
    
    func requestDidCancel(_ request: Request) {
        print("request가 cancel 되었습니다")
    }
    
}
extension Data {
    var toPrettyPrintedString: String? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.withoutEscapingSlashes, .prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }
        return prettyPrintedString as String
    }
}
