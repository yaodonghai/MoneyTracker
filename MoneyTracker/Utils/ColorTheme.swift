//
//  ColorTheme.swift
//  MoneyTracker
//
//  统一颜色主题，纯文字设计
//

import UIKit

enum ColorTheme {

    // MARK: - 主色
    /// 主色 - iOS蓝
    static let primary = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1)
    /// 收入绿
    static let income = UIColor(red: 52/255, green: 199/255, blue: 89/255, alpha: 1)
    /// 支出红
    static let expense = UIColor(red: 255/255, green: 59/255, blue: 48/255, alpha: 1)

    // MARK: - 背景
    static let background = UIColor(red: 242/255, green: 242/255, blue: 247/255, alpha: 1)
    static let cardBackground = UIColor.white
    static let secondaryBackground = UIColor(red: 229/255, green: 229/255, blue: 234/255, alpha: 1)

    // MARK: - 文字
    static let textPrimary = UIColor.black
    static let textSecondary = UIColor(red: 142/255, green: 142/255, blue: 147/255, alpha: 1)
    static let textTertiary = UIColor(red: 174/255, green: 174/255, blue: 178/255, alpha: 1)

    // MARK: - 分割线
    static let separator = UIColor(red: 198/255, green: 198/255, blue: 200/255, alpha: 1)

    // MARK: - 语义
    static let success = income
    static let warning = UIColor(red: 255/255, green: 204/255, blue: 0/255, alpha: 1)
}
