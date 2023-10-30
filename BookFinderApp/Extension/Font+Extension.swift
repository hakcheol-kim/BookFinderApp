//
//  Font+Extension.swift
//  BookFinder
//
//  Created by 김학철 on 2023/10/31.
//

import SwiftUI

public enum CTextStyle : CaseIterable {
    case largeTitle
    case h1
    case h2
    case h3
    case subhead
    case body1
    case body2
    case body3
    case body4
    case callout
    case caption1
    case caption2
    case button1
    case button2
    case none
    public static var allCases: [CTextStyle] = [.largeTitle, .h1, .h2,.h3, .subhead, .body1, .body2, .body3, .body4, .callout, .caption1, .caption2, .button1, .button2, .none]
}
extension CTextStyle {
    var cWeight: Font.Weight {
        switch self {
        case .largeTitle, .subhead, .body4, .callout, .caption1, .caption2, .button1, .button2:
            return .regular
        case .h1, .body1, .body2:
            return .bold
        case .h2, .body3:
            return .semibold
        case .h3:
            return .light
        default:
            return .regular
        }
    }
    var cSize: CGFloat {
        switch self {
        case .largeTitle:
            return 34
        case .h1:
            return 20
        case .body1:
            return 17
        case .h2, .h3, .button1:
            return 16
        case .body2, .body3:
            return 15
        case .subhead, .body4, .button2, .callout:
            return 13
        case .caption1:
            return 12
        case .caption2:
            return 11
        default:
            return 16
        }
    }
}
extension Font {
    static func custom(_ style: CTextStyle) -> Font {
        return .system(size: style.cSize, weight: style.cWeight)
    }
}
