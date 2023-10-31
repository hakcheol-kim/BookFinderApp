//
//  BookDetailView.swift
//  BookFinderApp
//
//  Created by 김학철 on 2023/10/31.
//

import SwiftUI
import SFSafeSymbols
import SDWebImageSwiftUI

struct BookDetailView: View {
    var item: BookModel
    @Environment(\.presentationMode) private var presentationMode
    var body: some View {
        ZStack {
            Color.primary10
                .ignoresSafeArea()
            
            VStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        HStack(alignment: .top, spacing: 20) {
                            WebImage(url: URL(string: item.thumbnail))
                                .resizable()
                                .placeholder {
                                    RoundedRectangle(cornerRadius: 4)
                                        .foregroundColor(.primary20)
                                }
                                .frame(width: 100, height: 120)
                                .scaledToFill()
                                .clipShape(RoundedRectangle(cornerRadius: 4))
                                .shadow(radius: 5)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("제목 : \(item.title)")
                                    .font(.custom(.h3))
                                    .foregroundColor(.primary90)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                if !item.subtitle.isEmpty {
                                    Text("부제 : \(item.subtitle)")
                                        .font(.custom(.subhead))
                                        .foregroundColor(.primary90)
                                }
                                if !item.authors.isEmpty {
                                    Text("저자: \(autuorDes(item.authors))")
                                        .font(.custom(.subhead))
                                        .foregroundColor(.primary60)
                                }
                                
                                if !item.publisher.isEmpty {
                                    Text("출판사 : \(item.publisher), ")
                                        .font(.custom(.subhead))
                                        .foregroundColor(.primary60)
                                }
                                
                                Text("출판일 : \(item.publishedDate)")
                                    .font(.custom(.subhead))
                                    .foregroundColor(.primary60)
                                
                            }
                        }
                        .padding(.vertical, 8)
                        
                        
                        if let saleInfo = item.saleInfo {
                            Text("판매 정보")
                                .font(.custom(.h2))
                                .foregroundColor(.primary100)
                                .padding(.top, 30)
                                .padding(.bottom, 16)
                            
                            if saleInfo.saleability == "NOT_FOR_SALE" {
                                Text("판매 불가")
                                    .font(.custom(.h1))
                                    .foregroundColor(.primary100)
                            }
                            else if saleInfo.saleability == "FOR_SALE" {
                                Text("정가: \(saleInfo.price.addComma())\(saleInfo.currencyCode)")
                                    .font(.custom(.h1))
                                    .foregroundColor(.primary100)
                                
                                HStack {
                                    Text("할인가: \(saleInfo.salePrice.addComma())\(saleInfo.currencyCode)")
                                        .font(.custom(.h1))
                                        .foregroundColor(.primary100)
                                        .padding(.top, 8)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    Button {
                                        guard let url = URL(string: saleInfo.buyLink) else { return }
                                        UIApplication.shared.open(url)
                                    } label: {
                                        Text("구매하기")
                                            .font(.custom(.body3))
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 8)
                                            .foregroundColor(.white)
                                            .background(Color.main)
                                            .clipShape(RoundedRectangle(cornerRadius: 8))
                                    }
                                    
                                }
                            }
                            else if saleInfo.saleability == "FREE" {
                                Text("무료")
                                    .font(.custom(.h1))
                                    .foregroundColor(.primary100)
                            }
                        }
                        
                        if !item.description.isEmpty {
                            Text(item.description)
                                .font(.custom(.h3))
                                .foregroundColor(.primary60)
                                .padding(.top, 30)
                        }
                        
                        Spacer()
                        
                    }
                    .padding(.horizontal, 16)
                }
                
                if !item.previewLink.isEmpty {
                    VStack {
                        Button {
                            guard let url = URL(string: item.previewLink) else { return }
                            UIApplication.shared.open(url)
                        } label: {
                            HStack {
                                Image(systemSymbol: .magnifyingglass)
                                    .font(.custom(.h2))
                                    .foregroundColor(.white)
                                
                                Text("미리보기 가기")
                                    .font(.custom(.h2))
                                    .foregroundColor(.white)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 54)
                            .background {
                                Color.main
                            }
                            .contentShape(Rectangle())
                            .clipShape(Capsule())
                        }
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                }
            }
        }
        .navigationApparance(bgColor: .primary10, fgColor: .primary100)
        .navigationTitle(item.title)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemSymbol: .chevronLeft)
                        .font(.custom(.h3))
                        .foregroundColor(.primary100)
                }
            }
        }
        .navigationBarTitleDisplayMode(.large)
        
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

//#Preview {
//    let model = BookModel(identifier: "", selfLink: "", title: "블라블라 블라블라", subtitle: "", description: "", publishedDate: "2023-01-01", authors: ["김티드"], publisher: "", thumbnail: "", smallThumbnail: "http://books.google.com/books/content?id=9nr0jwEACAAJ&printsec=frontcover&img=1&zoom=5&source=gbs_api", previewLink: "", language: "", pageCount: 0)
//    
//    BookDetailView(item: model)
//}
