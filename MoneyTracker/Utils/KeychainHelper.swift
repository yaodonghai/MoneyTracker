//
//  KeychainHelper.swift
//  MoneyTracker
//

import Foundation
import KeychainAccess

enum KeychainHelper {

    private static let keychain = Keychain(service: "com.tvbc.maiduiduidev.MoneyTracker")
    private static let lastUsernameKey = "lastUsername"

    static var lastUsername: String? {
        get { try? keychain.getString(lastUsernameKey) }
        set {
            if let v = newValue { try? keychain.set(v, key: lastUsernameKey) }
            else { try? keychain.remove(lastUsernameKey) }
        }
    }
}
