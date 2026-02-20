//
//  UserSession.swift
//  MoneyTracker
//
//  当前登录用户与用户库 DAO 访问
//

import Foundation
import FMDB

final class UserSession {

    static let shared = UserSession()

    private(set) var currentUser: User?
    private(set) var userDatabase: FMDatabase?
    private(set) var accountDAO: AccountDAO?
    private(set) var categoryDAO: CategoryDAO?
    private(set) var transactionDAO: TransactionDAO?

    private init() {}

    /// 使用全局库校验登录并切换用户
    func login(username: String, password: String) -> Bool {
        guard let globalDb = DatabaseManager.shared.openGlobalDatabase() else { return false }
        let userDao = UserDAO(database: globalDb)
        guard let user = userDao.findUser(byUsername: username),
              userDao.password(forUsername: username) == password else { return false }
        switchToUser(user)
        return true
    }

    /// 注册并自动登录
    func register(username: String, password: String) -> (success: Bool, message: String) {
        guard !username.trimmed.isEmpty else { return (false, "请输入用户名") }
        guard !password.isEmpty else { return (false, "请输入密码") }
        guard password.count >= 6 else { return (false, "密码至少6位") }
        guard let globalDb = DatabaseManager.shared.openGlobalDatabase() else { return (false, "数据库错误") }
        let userDao = UserDAO(database: globalDb)
        if userDao.findUser(byUsername: username) != nil { return (false, "用户名已存在") }
        guard userDao.insert(username: username, password: password) != nil else { return (false, "注册失败") }
        guard let user = userDao.findUser(byUsername: username) else { return (false, "注册失败") }
        switchToUser(user)
        return (true, "注册成功")
    }

    func switchToUser(_ user: User) {
        userDatabase?.close()
        userDatabase = nil
        accountDAO = nil
        categoryDAO = nil
        transactionDAO = nil

        currentUser = user
        guard let db = DatabaseManager.shared.openDatabase(userId: user.id) else {
            print("错误：无法打开用户数据库 userId=\(user.id)")
            return
        }
        userDatabase = db
        
        // 检查数据库是否真的打开
        if !db.isOpen {
            print("错误：数据库未打开")
            return
        }
        
        accountDAO = AccountDAO(database: db, userId: user.id)
        categoryDAO = CategoryDAO(database: db, userId: user.id)
        transactionDAO = TransactionDAO(database: db, userId: user.id)
        categoryDAO?.ensureDefaultCategories()
        ensureDefaultAccounts()
    }

    private func ensureDefaultAccounts() {
        guard let dao = accountDAO else { return }
        let list = dao.all()
        if list.isEmpty {
            _ = dao.insert(name: "现金", type: "cash", balance: 0)
            _ = dao.insert(name: "银行卡", type: "bank", balance: 0)
        }
    }

    func logout() {
        userDatabase?.close()
        userDatabase = nil
        accountDAO = nil
        categoryDAO = nil
        transactionDAO = nil
        currentUser = nil
    }

    var isLoggedIn: Bool { currentUser != nil }
}
