//
//  MainTabBarController.swift
//  MoneyTracker
//

import UIKit
import SnapKit

final class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.backgroundColor = ColorTheme.cardBackground
        tabBar.tintColor = ColorTheme.primary

        let home = HomeViewController()
        home.tabBarItem = UITabBarItem(title: "首页", image: nil, tag: 0)
        let homeNav = UINavigationController(rootViewController: home)

        let list = TransactionListViewController()
        list.tabBarItem = UITabBarItem(title: "账单", image: nil, tag: 1)
        let listNav = UINavigationController(rootViewController: list)

        let stats = StatisticsViewController()
        stats.tabBarItem = UITabBarItem(title: "统计", image: nil, tag: 2)
        let statsNav = UINavigationController(rootViewController: stats)

        let settings = SettingsViewController()
        settings.tabBarItem = UITabBarItem(title: "设置", image: nil, tag: 3)
        let settingsNav = UINavigationController(rootViewController: settings)

        viewControllers = [homeNav, listNav, statsNav, settingsNav]
    }
}
