//
//  SceneDelegate.swift
//  MoneyTracker
//
//  Created by 姚东海 on 2026/2/20.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        // 尝试自动登录
        if let lastUserId = KeychainHelper.lastUserId {
            if UserSession.shared.autoLogin(userId: lastUserId) {
                // 自动登录成功，直接进入主界面
                window?.rootViewController = MainTabBarController()
            } else {
                // 自动登录失败，显示登录页面
                window?.rootViewController = LoginViewController()
            }
        } else {
            // 没有保存的用户，显示登录页面
            window?.rootViewController = LoginViewController()
        }
        
        window?.makeKeyAndVisible()
    }

    /// 切换回登录页（如账号管理里“添加账号”）
    func showLogin() {
        UserSession.shared.logout()
        window?.rootViewController = LoginViewController()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

