//
//  KeychainHelper.swift
//  MoneyTracker
//

import Foundation
import KeychainAccess

enum KeychainHelper {

    private static let keychain = Keychain(service: "com.tvbc.maiduiduidev.MoneyTracker")
    private static let lastUsernameKey = "lastUsername"
    private static let lastUserIdKey = "lastUserId"

    static var lastUsername: String? {
        get { try? keychain.getString(lastUsernameKey) }
        set {
            if let v = newValue { try? keychain.set(v, key: lastUsernameKey) }
            else { try? keychain.remove(lastUsernameKey) }
        }
    }
    
    /// 保存最后登录的用户ID
    static var lastUserId: Int64? {
        get {
            guard let str = try? keychain.getString(lastUserIdKey),
                  let id = Int64(str) else { return nil }
            return id
        }
        set {
            if let v = newValue {
                try? keychain.set("\(v)", key: lastUserIdKey)
            } else {
                try? keychain.remove(lastUserIdKey)
            }
        }
    }
    
    /// 清除所有保存的登录信息
    static func clearLoginInfo() {
        lastUsername = nil
        lastUserId = nil
    }
}
