//
//  Transaction.swift
//  MoneyTracker
//

import Foundation

struct Transaction {
    let id: Int64
    let userId: Int64
    let type: String  // "income" | "expense"
    let amount: Double
    let categoryId: Int64
    let accountId: Int64
    let note: String?
    let date: String
    let createdAt: String

    init(id: Int64, userId: Int64, type: String, amount: Double, categoryId: Int64, accountId: Int64, note: String?, date: String, createdAt: String) {
        self.id = id
        self.userId = userId
        self.type = type
        self.amount = amount
        self.categoryId = categoryId
        self.accountId = accountId
        self.note = note
        self.date = date
        self.createdAt = createdAt
    }

    var isIncome: Bool { type == "income" }
}
