//
//  ApiService.swift
//  BookFinder
//
//  Created by 김학철 on 2023/10/31.
//

import Foundation
import Alamofire
import Combine

enum UserError: Error, Identifiable, Equatable {
    var id: String { UUID().uuidString }
    case sessionDeinitialized
    case invalidURL
    case sessionTaskFailed
    case parameterEncodingFailed
    case dataPasingFailed
    case unknown
    case customError(code: String, message: String)
    case originError(Error)
    
    
    var errorDescription: String? {
        switch self {
        case .sessionDeinitialized:
            return "세션 종료 되었습니다.\n다시 로그인 해주세요."
        case .invalidURL:
            return "잘못된 URL 입니다."
        case .sessionTaskFailed:
            return "인터넷 연결이 오프라인 상태입니다."
        case .customError(_ , let message):
            return message
        case .parameterEncodingFailed:
            return "요청 파라메터 인코딩에 실패했습니다."
        case .dataPasingFailed:
            return "데이터 파싱에 실패했습니다."
        case .originError(let error):
            return error.localizedDescription
        default:
            return "시스템 장애가 발생했습니다."
        }
    }
    
    static func ==(lhs: Self, rhs: Self) -> Bool { lhs.id == rhs.id }
}
protocol Routable {
    associatedtype Router: URLRequestConvertible
    static func request<T: Decodable>(_ router: Router, decoder: T.Type) -> AnyPublisher<T, UserError>
}

struct ApiService: Routable {
    
    typealias Router = ApiRouter
    
    static func request<T: Decodable>(_ router: Router, decoder: T.Type) -> AnyPublisher<T, UserError> {
        return AppSessionManager.default.session
            .request(router, interceptor: nil)
            .publishData()
            .tryMap ({ response -> T in
                switch response.result {
                case .success(let data):
                    guard let httpResponse = response.response else {
                        print("응답 오류")
                        throw UserError.unknown
                    }
                    
                    guard 200..<300 ~= httpResponse.statusCode else {
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any], let code = json["code"] as? String, let message = json["message"] as? String {
                            throw UserError.customError(code: code, message: "\(message)\n(code:\(code))")
                        }
                        else {
                            throw UserError.unknown
                        }
                    }
                    do {
                        let value = try JSONDecoder().decode(T.self, from: data)
                        return value
                    } catch {
                        throw UserError.dataPasingFailed
                    }
                case .failure(let error):
                    throw error
                }
            })
            .mapError { error -> UserError in
                if let error = error as? UserError {
                    return error
                } else if let error = error as? AFError {
                    return UserError.customError(code: "-999", message: error.errorDescription ?? "시스템 장애가 발생했습니다.")
                }
                return UserError.unknown
            }
            .eraseToAnyPublisher()
    }
}
