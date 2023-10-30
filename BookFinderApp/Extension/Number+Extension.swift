//
//  Number+Extension.swift
//  BookFinderApp
//
//  Created by 김학철 on 2023/10/31.
//

import SwiftUI
extension NumberFormatter {
    public func addComma(val: Any, digit: Int = 2) -> String {
        let fm = NumberFormatter()
        fm.maximumFractionDigits = digit
        fm.minimumFractionDigits = 0
        fm.numberStyle = .decimal
        guard let value = fm.string(for: val) else {
            return ""
        }
        return value
    }
}

extension Int {
    public func addComma(digit: Int = 2) -> String {
        let fm = NumberFormatter()
        fm.maximumFractionDigits = digit
        fm.minimumFractionDigits = 0
        fm.numberStyle = .decimal
        guard let value = fm.string(for: self) else {
            return ""
        }
        return value
    }
}
extension Double {
    public func addComma(digit: Int = 2) -> String {
        let fm = NumberFormatter()
        fm.maximumFractionDigits = digit
        fm.minimumFractionDigits = 0
        fm.numberStyle = .decimal
        guard let value = fm.string(for: self) else {
            return ""
        }
        return value
    }
}
