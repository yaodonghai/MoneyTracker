//
//  User.swift
//  MoneyTracker
//

import Foundation

struct User {
    let id: Int64
    let username: String
    let createdAt: String

    init(id: Int64, username: String, createdAt: String) {
        self.id = id
        self.username = username
        self.createdAt = createdAt
    }
}
