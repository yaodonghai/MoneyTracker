//
//  AccountDAO.swift
//  MoneyTracker
//

import Foundation
import FMDB

final class AccountDAO {

    private let db: FMDatabase
    private let userId: Int64

    init(database: FMDatabase, userId: Int64) {
        self.db = database
        self.userId = userId
    }

    func insert(name: String, type: String, balance: Double = 0) -> Int64? {
        let now = DateHelper.toDatabaseString(Date())
        let sql = "INSERT INTO accounts (user_id, name, type, balance, created_at) VALUES (?, ?, ?, ?, ?)"
        db.executeUpdate(sql, withArgumentsIn: [userId, name, type, balance, now])
        return db.lastInsertRowId > 0 ? db.lastInsertRowId : nil
    }

    func update(id: Int64, name: String?, type: String?, balance: Double?) -> Bool {
        if let name = name {
            db.executeUpdate("UPDATE accounts SET name = ? WHERE id = ? AND user_id = ?", withArgumentsIn: [name, id, userId])
        }
        if let type = type {
            db.executeUpdate("UPDATE accounts SET type = ? WHERE id = ? AND user_id = ?", withArgumentsIn: [type, id, userId])
        }
        if let balance = balance {
            db.executeUpdate("UPDATE accounts SET balance = ? WHERE id = ? AND user_id = ?", withArgumentsIn: [balance, id, userId])
        }
        return db.changes > 0
    }

    func updateBalance(accountId: Int64, newBalance: Double) -> Bool {
        db.executeUpdate("UPDATE accounts SET balance = ? WHERE id = ? AND user_id = ?", withArgumentsIn: [newBalance, accountId, userId])
        return db.changes > 0
    }

    func all() -> [Account] {
        let sql = "SELECT id, user_id, name, type, balance, created_at FROM accounts WHERE user_id = ? ORDER BY id"
        guard let rs = db.executeQuery(sql, withArgumentsIn: [userId]) else { return [] }
        return parseAccounts(rs)
    }

    func find(id: Int64) -> Account? {
        let sql = "SELECT id, user_id, name, type, balance, created_at FROM accounts WHERE id = ? AND user_id = ?"
        guard let rs = db.executeQuery(sql, withArgumentsIn: [id, userId]) else { return nil }
        guard rs.next() else { return nil }
        return parseAccount(rs)
    }

    func delete(id: Int64) -> Bool {
        db.executeUpdate("DELETE FROM accounts WHERE id = ? AND user_id = ?", withArgumentsIn: [id, userId])
        return db.changes > 0
    }

    private func parseAccount(_ rs: FMResultSet) -> Account {
        Account(
            id: rs.longLongInt(forColumn: "id"),
            userId: rs.longLongInt(forColumn: "user_id"),
            name: rs.string(forColumn: "name") ?? "",
            type: rs.string(forColumn: "type") ?? "",
            balance: rs.double(forColumn: "balance"),
            createdAt: rs.string(forColumn: "created_at") ?? ""
        )
    }

    private func parseAccounts(_ rs: FMResultSet) -> [Account] {
        var list: [Account] = []
        while rs.next() { list.append(parseAccount(rs)) }
        return list
    }
}
