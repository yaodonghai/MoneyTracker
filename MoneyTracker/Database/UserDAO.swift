//
//  UserDAO.swift
//  MoneyTracker
//

import Foundation
import FMDB

final class UserDAO {

    private let db: FMDatabase

    init(database: FMDatabase) {
        self.db = database
    }

    /// 注册：插入用户，返回 userId
    func insert(username: String, password: String) -> Int64? {
        let now = DateHelper.toDatabaseString(Date())
        let sql = "INSERT INTO users (username, password, created_at) VALUES (?, ?, ?)"
        db.executeUpdate(sql, withArgumentsIn: [username, password, now])
        return db.lastInsertRowId > 0 ? db.lastInsertRowId : nil
    }

    /// 根据用户名查用户（登录校验）
    func findUser(byUsername username: String) -> User? {
        let sql = "SELECT id, username, created_at FROM users WHERE username = ?"
        guard let rs = db.executeQuery(sql, withArgumentsIn: [username]) else { return nil }
        guard rs.next() else { return nil }
        let id = rs.longLongInt(forColumnIndex: 0)
        let uname = rs.string(forColumnIndex: 1) ?? ""
        let created = rs.string(forColumnIndex: 2) ?? ""
        return User(id: id, username: uname, createdAt: created)
    }

    /// 校验密码：需单独查 password
    func password(forUsername username: String) -> String? {
        let sql = "SELECT password FROM users WHERE username = ?"
        guard let rs = db.executeQuery(sql, withArgumentsIn: [username]) else { return nil }
        guard rs.next() else { return nil }
        return rs.string(forColumn: "password")
    }

    /// 所有用户（用于账号列表）
    func allUsers() -> [User] {
        let sql = "SELECT id, username, created_at FROM users ORDER BY id"
        guard let rs = db.executeQuery(sql, withArgumentsIn: []) else { return [] }
        var list: [User] = []
        while rs.next() {
            list.append(User(
                id: rs.longLongInt(forColumn: "id"),
                username: rs.string(forColumn: "username") ?? "",
                createdAt: rs.string(forColumn: "created_at") ?? ""
            ))
        }
        return list
    }

    func delete(userId: Int64) -> Bool {
        db.executeUpdate("DELETE FROM users WHERE id = ?", withArgumentsIn: [userId])
        return db.changes > 0
    }
}
