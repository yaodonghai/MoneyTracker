//
//  TransactionListViewController.swift
//  MoneyTracker
//

import UIKit
import SnapKit

final class TransactionListViewController: UIViewController {

    private let addBarItem = UIBarButtonItem(title: "记一笔", style: .plain, target: nil, action: nil)
    private let tableView: UITableView = {
        let t = UITableView(frame: .zero, style: .plain)
        t.rowHeight = 56
        t.tableFooterView = UIView()
        return t
    }()

    private var sections: [(date: String, list: [Transaction])] = []
    private var allList: [Transaction] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "账单"
        view.backgroundColor = ColorTheme.background
        navigationItem.rightBarButtonItem = addBarItem
        addBarItem.target = self
        addBarItem.action = #selector(openAdd)

        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(reload), for: .valueChanged)
        tableView.register(TransactionCell.self, forCellReuseIdentifier: TransactionCell.reuseId)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reload()
    }

    @objc private func reload() {
        allList = UserSession.shared.transactionDAO?.list(limit: 500) ?? []
        var dict: [String: [Transaction]] = [:]
        for t in allList {
            let day = String(t.date.prefix(10))
            dict[day, default: []].append(t)
        }
        sections = dict.sorted { $0.key > $1.key }.map { ($0.key, $0.value) }
        tableView.reloadData()
        tableView.refreshControl?.endRefreshing()
    }

    @objc private func openAdd() {
        let vc = AddTransactionViewController()
        vc.onSaved = { [weak self] in self?.reload() }
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true)
    }
}

extension TransactionListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int { sections.count }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].list.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let date = DateHelper.fromDatabaseString(sections[section].date + " 00:00:00") else { return sections[section].date }
        return DateHelper.displayDate(date)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TransactionCell.reuseId, for: indexPath) as! TransactionCell
        let t = sections[indexPath.section].list[indexPath.row]
        cell.configure(t, categoryDAO: UserSession.shared.categoryDAO, accountDAO: UserSession.shared.accountDAO)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let t = sections[indexPath.section].list[indexPath.row]
        let vc = TransactionDetailViewController(transaction: t)
        vc.onDeleted = { [weak self] in self?.reload() }
        navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let t = sections[indexPath.section].list[indexPath.row]
            _ = UserSession.shared.transactionDAO?.delete(id: t.id)
            reload()
        }
    }
}
