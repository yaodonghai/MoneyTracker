//
//  CategoryDAO.swift
//  MoneyTracker
//

import Foundation
import FMDB

final class CategoryDAO {

    private let db: FMDatabase
    private let userId: Int64

    init(database: FMDatabase, userId: Int64) {
        self.db = database
        self.userId = userId
    }

    func insert(name: String, type: String, icon: String?, isSystem: Bool) -> Int64? {
        let now = DateHelper.toDatabaseString(Date())
        let sql = "INSERT INTO categories (user_id, name, type, icon, is_system, created_at) VALUES (?, ?, ?, ?, ?, ?)"
        let sys = isSystem ? 1 : 0
        db.executeUpdate(sql, withArgumentsIn: [userId, name, type, icon ?? "", sys, now])
        return db.lastInsertRowId > 0 ? db.lastInsertRowId : nil
    }

    func update(id: Int64, name: String?, icon: String?) -> Bool {
        if let name = name {
            db.executeUpdate("UPDATE categories SET name = ? WHERE id = ? AND user_id = ?", withArgumentsIn: [name, id, userId])
        }
        if let icon = icon {
            db.executeUpdate("UPDATE categories SET icon = ? WHERE id = ? AND user_id = ?", withArgumentsIn: [icon, id, userId])
        }
        return db.changes > 0
    }

    func all(type: String? = nil) -> [Category] {
        var sql = "SELECT id, user_id, name, type, icon, is_system, created_at FROM categories WHERE user_id = ?"
        var args: [Any] = [userId]
        if let t = type {
            sql += " AND type = ?"
            args.append(t)
        }
        sql += " ORDER BY is_system DESC, id"
        guard let rs = db.executeQuery(sql, withArgumentsIn: args) else { return [] }
        return parseCategories(rs)
    }

    func find(id: Int64) -> Category? {
        let sql = "SELECT id, user_id, name, type, icon, is_system, created_at FROM categories WHERE id = ? AND user_id = ?"
        guard let rs = db.executeQuery(sql, withArgumentsIn: [id, userId]) else { return nil }
        guard rs.next() else { return nil }
        return parseCategory(rs)
    }

    func delete(id: Int64) -> Bool {
        db.executeUpdate("DELETE FROM categories WHERE id = ? AND user_id = ? AND is_system = 0", withArgumentsIn: [id, userId])
        return db.changes > 0
    }

    /// 确保预设分类存在
    func ensureDefaultCategories() {
        let expenseList = DefaultCategories.expense
        for item in expenseList {
            if !exists(name: item.name, type: "expense") {
                _ = insert(name: item.name, type: "expense", icon: item.icon, isSystem: true)
            }
        }
        let incomeList = DefaultCategories.income
        for item in incomeList {
            if !exists(name: item.name, type: "income") {
                _ = insert(name: item.name, type: "income", icon: item.icon, isSystem: true)
            }
        }
    }

    private func exists(name: String, type: String) -> Bool {
        let sql = "SELECT 1 FROM categories WHERE user_id = ? AND name = ? AND type = ? LIMIT 1"
        guard let rs = db.executeQuery(sql, withArgumentsIn: [userId, name, type]) else { return false }
        return rs.next()
    }

    private func parseCategory(_ rs: FMResultSet) -> Category {
        Category(
            id: rs.longLongInt(forColumn: "id"),
            userId: rs.longLongInt(forColumn: "user_id"),
            name: rs.string(forColumn: "name") ?? "",
            type: rs.string(forColumn: "type") ?? "",
            icon: rs.string(forColumn: "icon").flatMap { $0.isEmpty ? nil : $0 },
            isSystem: rs.longLongInt(forColumn: "is_system") != 0,
            createdAt: rs.string(forColumn: "created_at") ?? ""
        )
    }

    private func parseCategories(_ rs: FMResultSet) -> [Category] {
        var list: [Category] = []
        while rs.next() { list.append(parseCategory(rs)) }
        return list
    }
}
