//
//  MainListCell.swift
//  BookFinderApp
//
//  Created by 김학철 on 2023/10/31.
//

import SwiftUI
import SDWebImageSwiftUI

struct MainListCell: View {
    var item: BookModel
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 20) {
                WebImage(url: URL(string: item.smallThumbnail))
                    .resizable()
                    .placeholder {
                        RoundedRectangle(cornerRadius: 4)
                            .foregroundColor(.primary20)
                    }
                    .frame(width: 75, height: 105)
                    .scaledToFill()
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                    .shadow(radius: 5)
                
                VStack(spacing: 8) {
                    Text(item.title)
                        .font(.custom(.h3))
                        .foregroundColor(.primary90)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .lineLimit(2)
                    
                    Text(autuorDes(item.authors))
                        .font(.custom(.subhead))
                        .foregroundColor(.primary60)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(item.publishedDate)
                        .font(.custom(.subhead))
                        .foregroundColor(.primary60)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            
            Divider()
        }
    }
    func autuorDes(_ authors: [String]) -> String {
        var des = ""
        authors.forEach { author in
            des.append("\(author), ")
        }
        if authors.count > 0 {
            des = String(des.dropLast(2))
        }
        return des
    }
}
struct MainListCell_Previews: PreviewProvider {
    static var previews: some View {
        let model = BookModel(identifier: "", selfLink: "", title: "블라블라 블라블라", subtitle: "", description: "", publishedDate: "2023-01-01", authors: ["김티드"], publisher: "", thumbnail: "", smallThumbnail: "http://books.google.com/books/content?id=9nr0jwEACAAJ&printsec=frontcover&img=1&zoom=5&source=gbs_api", previewLink: "", language: "", pageCount: 0)
        
        MainListCell(item: model)
        
    }
}
