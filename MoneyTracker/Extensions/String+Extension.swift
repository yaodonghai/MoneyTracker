//
//  String+Extension.swift
//  MoneyTracker
//

import Foundation

extension String {

    /// 去除首尾空白
    var trimmed: String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// 是否为空（仅空白视为空）
    var isBlank: Bool {
        trimmed.isEmpty
    }
}
