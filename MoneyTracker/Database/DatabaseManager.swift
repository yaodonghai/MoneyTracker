//
//  DatabaseManager.swift
//  MoneyTracker
//
//  单例，管理 SQLite 数据库创建与表结构
//

import Foundation
import FMDB

final class DatabaseManager {

    static let shared = DatabaseManager()

    private let dbPath: String
    private var db: FMDatabase?

    private init() {
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        dbPath = dir.appendingPathComponent("moneytracker.db").path
    }

    /// 为指定用户打开/创建独立库（按用户隔离数据：每个用户一个 db 文件）
    func openDatabase(userId: Int64) -> FMDatabase? {
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let path = dir.appendingPathComponent("mt_user_\(userId).db").path
        let database = FMDatabase(path: path)
        guard database.open() else {
            print("错误：无法打开数据库，路径=\(path)，错误=\(database.lastError())")
            return nil
        }
        createTablesIfNeeded(database)
        return database
    }

    /// 全局库：仅存 users 表，用于登录校验与多账号
    func openGlobalDatabase() -> FMDatabase? {
        if db == nil {
            db = FMDatabase(path: dbPath)
            if db?.open() == true {
                createGlobalTablesIfNeeded(db!)
            } else {
                db = nil
            }
        }
        return db
    }

    private func createGlobalTablesIfNeeded(_ database: FMDatabase) {
        let sql = """
        CREATE TABLE IF NOT EXISTS users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT UNIQUE NOT NULL,
            password TEXT NOT NULL,
            created_at TEXT NOT NULL
        );
        """
        database.executeStatements(sql)
    }

    private func createTablesIfNeeded(_ database: FMDatabase) {
        let accounts = """
        CREATE TABLE IF NOT EXISTS accounts (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER NOT NULL,
            name TEXT NOT NULL,
            type TEXT NOT NULL,
            balance REAL DEFAULT 0.0,
            created_at TEXT NOT NULL
        );
        """
        let categories = """
        CREATE TABLE IF NOT EXISTS categories (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER NOT NULL,
            name TEXT NOT NULL,
            type TEXT NOT NULL,
            icon TEXT,
            is_system INTEGER DEFAULT 0,
            created_at TEXT NOT NULL
        );
        """
        let transactions = """
        CREATE TABLE IF NOT EXISTS transactions (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER NOT NULL,
            type TEXT NOT NULL,
            amount REAL NOT NULL,
            category_id INTEGER NOT NULL,
            account_id INTEGER NOT NULL,
            note TEXT,
            date TEXT NOT NULL,
            created_at TEXT NOT NULL
        );
        """
        database.executeStatements(accounts)
        database.executeStatements(categories)
        database.executeStatements(transactions)
    }

    func closeUserDatabase(userId: Int64) {
        // 每个用户库由 DAO 层持有并关闭；这里仅关闭全局库（如需要可扩展）
    }

    func closeGlobal() {
        db?.close()
        db = nil
    }
}
