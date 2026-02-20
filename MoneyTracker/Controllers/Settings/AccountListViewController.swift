//
//  AccountListViewController.swift
//  MoneyTracker
//

import UIKit
import SnapKit

final class AccountListViewController: UIViewController {

    private var users: [User] = []
    private let tableView: UITableView = {
        let t = UITableView(frame: .zero, style: .plain)
        t.rowHeight = 52
        return t
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "账号管理"
        view.backgroundColor = ColorTheme.background
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "添加账号", style: .plain, target: self, action: #selector(addAccount))
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in make.edges.equalToSuperview() }
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadUsers()
    }

    private func loadUsers() {
        guard let db = DatabaseManager.shared.openGlobalDatabase() else { return }
        users = UserDAO(database: db).allUsers()
        tableView.reloadData()
    }

    @objc private func addAccount() {
        UserSession.shared.logout()
        (view.window?.windowScene?.delegate as? SceneDelegate)?.showLogin()
    }

    private func switchTo(user: User) {
        UserSession.shared.switchToUser(user)
        navigationController?.popViewController(animated: true)
    }
}

extension AccountListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { users.count }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        let u = users[indexPath.row]
        cell.textLabel?.text = u.username
        cell.detailTextLabel?.text = u.createdAt
        cell.accessoryType = UserSession.shared.currentUser?.id == u.id ? .checkmark : .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switchTo(user: users[indexPath.row])
    }
}
