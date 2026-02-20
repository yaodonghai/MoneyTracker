//
//  Category.swift
//  MoneyTracker
//

import Foundation

struct Category {
    let id: Int64
    let userId: Int64
    let name: String
    let type: String  // "income" | "expense"
    let icon: String?
    let isSystem: Bool
    let createdAt: String

    init(id: Int64, userId: Int64, name: String, type: String, icon: String?, isSystem: Bool, createdAt: String) {
        self.id = id
        self.userId = userId
        self.name = name
        self.type = type
        self.icon = icon
        self.isSystem = isSystem
        self.createdAt = createdAt
    }
}

// 预设分类
enum DefaultCategories {

    static let expense: [(name: String, icon: String)] = [
        ("餐饮", "食"),
        ("交通", "行"),
        ("购物", "购"),
        ("娱乐", "乐"),
        ("医疗", "医"),
        ("教育", "教"),
        ("住房", "住"),
        ("其他", "其")
    ]

    static let income: [(name: String, icon: String)] = [
        ("工资", "薪"),
        ("奖金", "奖"),
        ("投资", "投"),
        ("兼职", "兼"),
        ("其他", "其")
    ]
}
