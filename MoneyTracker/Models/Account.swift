//
//  Account.swift
//  MoneyTracker
//

import Foundation

struct Account {
    let id: Int64
    let userId: Int64
    let name: String
    let type: String
    var balance: Double
    let createdAt: String

    init(id: Int64, userId: Int64, name: String, type: String, balance: Double, createdAt: String) {
        self.id = id
        self.userId = userId
        self.name = name
        self.type = type
        self.balance = balance
        self.createdAt = createdAt
    }

    /// 账户类型显示名
    static func displayName(for type: String) -> String {
        switch type {
        case "cash": return "现金"
        case "bank": return "银行卡"
        case "alipay": return "支付宝"
        case "wechat": return "微信"
        case "credit": return "信用卡"
        default: return "其他"
        }
    }

    static let allTypes: [(id: String, name: String)] = [
        ("cash", "现金"),
        ("bank", "银行卡"),
        ("alipay", "支付宝"),
        ("wechat", "微信"),
        ("credit", "信用卡"),
        ("other", "其他")
    ]
}
