//
//  AccountManagerViewController.swift
//  MoneyTracker
//

import UIKit
import SnapKit

final class AccountManagerViewController: UIViewController {

    private var accounts: [Account] = []
    private let tableView: UITableView = {
        let t = UITableView(frame: .zero, style: .plain)
        t.rowHeight = 56
        return t
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "账户管理"
        view.backgroundColor = ColorTheme.background
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "添加", style: .plain, target: self, action: #selector(addAccount))
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in make.edges.equalToSuperview() }
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        accounts = UserSession.shared.accountDAO?.all() ?? []
        tableView.reloadData()
    }

    @objc private func addAccount() {
        let alert = UIAlertController(title: "添加账户", message: nil, preferredStyle: .alert)
        alert.addTextField { $0.placeholder = "名称" }
        alert.addAction(UIAlertAction(title: "取消", style: .cancel))
        alert.addAction(UIAlertAction(title: "确定", style: .default) { [weak self] _ in
            let name = alert.textFields?.first?.text?.trimmed ?? "新账户"
            _ = UserSession.shared.accountDAO?.insert(name: name, type: "other", balance: 0)
            self?.accounts = UserSession.shared.accountDAO?.all() ?? []
            self?.tableView.reloadData()
        })
        present(alert, animated: true)
    }
}

extension AccountManagerViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { accounts.count }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        let a = accounts[indexPath.row]
        cell.textLabel?.text = a.name
        cell.detailTextLabel?.text = String(format: "%.2f", a.balance)
        return cell
    }
}
