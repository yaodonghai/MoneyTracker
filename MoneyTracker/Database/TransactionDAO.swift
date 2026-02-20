//
//  TransactionDAO.swift
//  MoneyTracker
//

import Foundation
import FMDB

final class TransactionDAO {

    private let db: FMDatabase
    private let userId: Int64

    init(database: FMDatabase, userId: Int64) {
        self.db = database
        self.userId = userId
    }

    func insert(type: String, amount: Double, categoryId: Int64, accountId: Int64, note: String?, date: String) -> Int64? {
        let now = DateHelper.toDatabaseString(Date())
        let sql = "INSERT INTO transactions (user_id, type, amount, category_id, account_id, note, date, created_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?)"
        let success = db.executeUpdate(sql, withArgumentsIn: [userId, type, amount, categoryId, accountId, note ?? "", date, now])
        if !success {
            print("数据库错误: \(db.lastError())")
            return nil
        }
        let rowId = db.lastInsertRowId
        return rowId > 0 ? rowId : nil
    }

    func update(id: Int64, type: String?, amount: Double?, categoryId: Int64?, accountId: Int64?, note: String?, date: String?) -> Bool {
        var sets: [String] = []
        var args: [Any] = []
        if let type = type { sets.append("type = ?"); args.append(type) }
        if let amount = amount { sets.append("amount = ?"); args.append(amount) }
        if let categoryId = categoryId { sets.append("category_id = ?"); args.append(categoryId) }
        if let accountId = accountId { sets.append("account_id = ?"); args.append(accountId) }
        if let note = note { sets.append("note = ?"); args.append(note) }
        if let date = date { sets.append("date = ?"); args.append(date) }
        guard !sets.isEmpty else { return false }
        args.append(id)
        args.append(userId)
        let sql = "UPDATE transactions SET \(sets.joined(separator: ", ")) WHERE id = ? AND user_id = ?"
        db.executeUpdate(sql, withArgumentsIn: args)
        return db.changes > 0
    }

    func find(id: Int64) -> Transaction? {
        let sql = "SELECT id, user_id, type, amount, category_id, account_id, note, date, created_at FROM transactions WHERE id = ? AND user_id = ?"
        guard let rs = db.executeQuery(sql, withArgumentsIn: [id, userId]) else { return nil }
        guard rs.next() else { return nil }
        return parseTransaction(rs)
    }

    func list(limit: Int = 100, offset: Int = 0, type: String? = nil, fromDate: String? = nil, toDate: String? = nil) -> [Transaction] {
        var sql = "SELECT id, user_id, type, amount, category_id, account_id, note, date, created_at FROM transactions WHERE user_id = ?"
        var args: [Any] = [userId]
        if let t = type { sql += " AND type = ?"; args.append(t) }
        if let from = fromDate { sql += " AND date >= ?"; args.append(from) }
        if let to = toDate { sql += " AND date <= ?"; args.append(to) }
        sql += " ORDER BY date DESC, id DESC LIMIT ? OFFSET ?"
        args.append(limit)
        args.append(offset)
        guard let rs = db.executeQuery(sql, withArgumentsIn: args) else { return [] }
        return parseTransactions(rs)
    }

    func recent(limit: Int = 5) -> [Transaction] {
        list(limit: limit, offset: 0)
    }

    func sumIncome(from: String, to: String) -> Double {
        let sql = "SELECT COALESCE(SUM(amount), 0) FROM transactions WHERE user_id = ? AND type = 'income' AND date >= ? AND date <= ?"
        guard let rs = db.executeQuery(sql, withArgumentsIn: [userId, from, to]) else { return 0 }
        return rs.next() ? rs.double(forColumnIndex: 0) : 0
    }

    func sumExpense(from: String, to: String) -> Double {
        let sql = "SELECT COALESCE(SUM(amount), 0) FROM transactions WHERE user_id = ? AND type = 'expense' AND date >= ? AND date <= ?"
        guard let rs = db.executeQuery(sql, withArgumentsIn: [userId, from, to]) else { return 0 }
        return rs.next() ? rs.double(forColumnIndex: 0) : 0
    }

    func delete(id: Int64) -> Bool {
        db.executeUpdate("DELETE FROM transactions WHERE id = ? AND user_id = ?", withArgumentsIn: [id, userId])
        return db.changes > 0
    }

    private func parseTransaction(_ rs: FMResultSet) -> Transaction {
        Transaction(
            id: rs.longLongInt(forColumn: "id"),
            userId: rs.longLongInt(forColumn: "user_id"),
            type: rs.string(forColumn: "type") ?? "",
            amount: rs.double(forColumn: "amount"),
            categoryId: rs.longLongInt(forColumn: "category_id"),
            accountId: rs.longLongInt(forColumn: "account_id"),
            note: rs.string(forColumn: "note").flatMap { $0.isEmpty ? nil : $0 },
            date: rs.string(forColumn: "date") ?? "",
            createdAt: rs.string(forColumn: "created_at") ?? ""
        )
    }

    private func parseTransactions(_ rs: FMResultSet) -> [Transaction] {
        var list: [Transaction] = []
        while rs.next() { list.append(parseTransaction(rs)) }
        return list
    }
}
