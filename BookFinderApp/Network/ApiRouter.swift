//
//  ApiRouter.swift
//  BookFinder
//
//  Created by 김학철 on 2023/10/31.
//

import Foundation
import Alamofire

enum ApiRouter {
    case searchBooks([String:Any])
}
extension ApiRouter: URLRequestConvertible {
    
    var baseURL: URL {
        return URL(string: AppConstants.baseUrl)!
    }
    
    var endPoint: String {
        switch self {
        case .searchBooks:
            return "/books/v1/volumes"
        }
    }
    
    var method: HTTPMethod {
        return .get
        
    }
    var headers: HTTPHeaders {
        var headers = HTTPHeaders()
        switch self {
        default:
            headers.add(HTTPHeader(name: "Content-type", value: "application/json"))
            break
        }
        return headers
    }
    
    var parameters: Parameters? {
        switch self {
        default:
            return nil
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let urlStr = baseURL.appendingPathComponent(endPoint).absoluteString.removingPercentEncoding!
        var request = URLRequest(url: URL(string: urlStr)!)
        if let parameters = parameters {
            switch self {
            case .searchBooks:
                request = try URLEncoding.default.encode(request, with: parameters)
            default:
                request = try JSONEncoding(options: [.withoutEscapingSlashes]).encode(request, with: parameters)
            }
        }
//            request = try JSONEncoding.default.encode(request, with: parameters)
        return request
    }
}
