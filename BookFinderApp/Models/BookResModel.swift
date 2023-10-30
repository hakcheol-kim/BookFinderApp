//
//  BookResModel.swift
//  BookFinderApp
//
//  Created by 김학철 on 2023/10/31.
//

import SwiftUI
import SwiftyJSON

struct SaleInfo: Codable {
    var saleability: String
    var price: Int
    var country: String
    var currencyCode: String
    var salePrice: Int
    var buyLink: String
    
    enum CodingKeys: String, CodingKey {
        case saleability
        case price
        case country
        case currencyCode
        case salePrice
        case buyLink
        
        case listPrice
        case retailPrice
    }
    func encode(to encoder: Encoder) throws {
        
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.saleability = try container.decodeIfPresent(String.self, forKey: .saleability) ?? ""
        self.country = try container.decodeIfPresent(String.self, forKey: .country) ?? ""
        self.buyLink = try container.decodeIfPresent(String.self, forKey: .buyLink) ?? ""
        
        let listPrice = try container.decodeIfPresent(JSON.self, forKey: .listPrice)
        self.price = listPrice?["amount"].intValue ?? 0
        let retailPrice = try container.decodeIfPresent(JSON.self, forKey: .retailPrice)
        self.salePrice = retailPrice?["amount"].intValue ?? 0
        self.currencyCode = retailPrice?["currencyCode"].stringValue ?? ""
    }
}
struct AccessInfo: Codable {
    var isAvailableEbook: Bool
    var acsTokenLinkEbook: String
    var downloadLinkEbook: String
    var isAvailablePdf: Bool
    var acsTokenLinkPdf: String
    var downloadLinkPdf: String
    
    enum CodingKeys: CodingKey {
        case isAvailableEbook
        case acsTokenLinkEbook
        case downloadLinkEbook
        case isAvailablePdf
        case acsTokenLinkPdf
        case downloadLinkPdf
        
        case accessInfo
    }
    func encode(to encoder: Encoder) throws {
        
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let accessInfo = try container.decodeIfPresent(JSON.self, forKey: .accessInfo) {
            self.isAvailableEbook = accessInfo["epub"].dictionaryValue["isAvailable"]?.boolValue ?? false
            self.acsTokenLinkEbook = accessInfo["epub"].dictionaryValue["acsTokenLink"]?.stringValue ?? ""
            self.downloadLinkEbook = accessInfo["epub"].dictionaryValue["downloadLink"]?.stringValue ?? ""
            
            self.isAvailablePdf = accessInfo["pdf"].dictionaryValue["isAvailable"]?.boolValue ?? false
            self.acsTokenLinkPdf = accessInfo["pdf"].dictionaryValue["acsTokenLink"]?.stringValue ?? ""
            self.downloadLinkPdf = accessInfo["pdf"].dictionaryValue["downloadLink"]?.stringValue ?? ""
        }
        else {
            self.isAvailableEbook = false
            self.acsTokenLinkEbook =  ""
            self.downloadLinkEbook = ""
            
            self.isAvailablePdf = false
            self.acsTokenLinkPdf = ""
            self.downloadLinkPdf = ""
        }
    }
}
struct BookModel: Identifiable, Codable, Equatable, Hashable {
    var id: String {
        identifier
    }
    var identifier: String
    var selfLink: String    //해당도서 데이터
    var title: String
    var subtitle: String
    var description: String
    var publishedDate: String
    var authors: [String]
    var publisher: String   //출판사
    var thumbnail: String
    var smallThumbnail: String
    var previewLink: String //미리보기 링크
    var language: String //
    var pageCount: Int
    
    enum CodingKeys: CodingKey {
        case selfLink
        case title
        case description
        case publishedDate
        case authors
        case publisher
        case thumbnail
        case smallThumbnail
        case previewLink
        case language
        case pageCount
        case id
        case volumeInfo
    }
    func encode(to encoder: Encoder) throws {
        
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.identifier = try container.decodeIfPresent(String.self, forKey: .id) ?? ""
        self.selfLink = try container.decodeIfPresent(String.self, forKey: .selfLink) ?? ""
        
        if let volumeInfo = try container.decodeIfPresent(JSON.self, forKey: .volumeInfo) {
            self.title = volumeInfo["title"].stringValue
            self.subtitle = volumeInfo["subtitle"].stringValue
            self.description = volumeInfo["description"].stringValue
            self.publishedDate = volumeInfo["publishedDate"].stringValue
            self.publisher = volumeInfo["publisher"].stringValue
            self.authors = volumeInfo["authors"].arrayObject as? [String] ?? []
            self.pageCount = volumeInfo["pageCount"].intValue
            self.language = volumeInfo["language"].stringValue
            self.previewLink = volumeInfo["previewLink"].stringValue
            self.thumbnail = volumeInfo["imageLinks"].dictionaryValue["thumbnail"]?.stringValue ?? ""
            self.smallThumbnail = volumeInfo["imageLinks"].dictionaryValue["smallThumbnail"]?.stringValue ?? ""
        }
        else {
            self.title = ""
            self.subtitle = ""
            self.description = ""
            self.publishedDate = ""
            self.publisher = ""
            self.authors = []
            self.pageCount = 0
            self.language = ""
            self.previewLink = ""
            self.thumbnail = ""
            self.smallThumbnail = ""
        }
    }
    static func ==(lhs: Self, rhs: Self) ->Bool {
        return lhs.id == rhs.id
    }
    init(identifier: String = "", selfLink: String = "", title: String = "", subtitle: String = "", description: String = "", publishedDate: String = "", authors: [String] = [], publisher: String = "", thumbnail: String = "", smallThumbnail: String = "", previewLink: String = "", language: String = "", pageCount: Int = 0) {
        self.identifier = identifier
        self.selfLink = selfLink
        self.title = title
        self.subtitle = subtitle
        self.description = description
        self.publishedDate = publishedDate
        self.authors = authors
        self.publisher = publisher
        self.thumbnail = thumbnail
        self.smallThumbnail = smallThumbnail
        self.previewLink = previewLink
        self.language = language
        self.pageCount = pageCount
    }
}

struct BookResModel: Codable {
    var totalItems: Int
    var items: [BookModel]
    
    enum CodingKeys: CodingKey {
        case totalItems
        case items
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.totalItems = try container.decodeIfPresent(Int.self, forKey: .totalItems) ?? 0
        self.items = try container.decodeIfPresent([BookModel].self, forKey: .items) ?? []
    }
}
