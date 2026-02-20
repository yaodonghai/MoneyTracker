//
//  FontManager.swift
//  MoneyTracker
//
//  统一字体规范
//

import UIKit

enum FontManager {

    /// 大标题
    static func largeTitle(weight: UIFont.Weight = .bold) -> UIFont {
        .systemFont(ofSize: 28, weight: weight)
    }

    /// 标题1
    static func title1(weight: UIFont.Weight = .bold) -> UIFont {
        .systemFont(ofSize: 22, weight: weight)
    }

    /// 标题2
    static func title2(weight: UIFont.Weight = .bold) -> UIFont {
        .systemFont(ofSize: 20, weight: weight)
    }

    /// 标题3
    static func title3(weight: UIFont.Weight = .semibold) -> UIFont {
        .systemFont(ofSize: 17, weight: weight)
    }

    /// 正文
    static func body(weight: UIFont.Weight = .regular) -> UIFont {
        .systemFont(ofSize: 17, weight: weight)
    }

    /// 副标题
    static func callout(weight: UIFont.Weight = .regular) -> UIFont {
        .systemFont(ofSize: 16, weight: weight)
    }

    /// 脚注
    static func footnote(weight: UIFont.Weight = .regular) -> UIFont {
        .systemFont(ofSize: 13, weight: weight)
    }

    /// 金额大号
    static func amountLarge(weight: UIFont.Weight = .semibold) -> UIFont {
        .systemFont(ofSize: 32, weight: weight)
    }

    /// 金额中号
    static func amountMedium(weight: UIFont.Weight = .medium) -> UIFont {
        .systemFont(ofSize: 20, weight: weight)
    }
}
