//
//  SettingsViewController.swift
//  MoneyTracker
//

import UIKit
import SnapKit

final class SettingsViewController: UIViewController {

    private let tableView: UITableView = {
        let t = UITableView(frame: .zero, style: .insetGrouped)
        t.rowHeight = 48
        return t
    }()

    private let sections: [[(title: String, action: () -> Void)]] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "设置"
        view.backgroundColor = ColorTheme.background
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in make.edges.equalToSuperview() }
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    private func rows() -> [(section: String, rows: [String])] {
        var result: [(String, [String])] = []
        result.append(("账号", ["当前账号：\(UserSession.shared.currentUser?.username ?? "")", "账号管理"]))
        result.append(("数据", ["分类管理", "账户管理", "导出数据"]))
        result.append(("其他", ["关于"]))
        return result
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int { rows().count }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rows()[section].rows.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        rows()[section].section
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        cell.textLabel?.text = rows()[indexPath.section].rows[indexPath.row]
        cell.textLabel?.font = FontManager.callout()
        cell.accessoryType = indexPath.section == 0 && indexPath.row == 0 ? .none : .disclosureIndicator
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let (section, rows) = rows()[indexPath.section]
        let rowTitle = rows[indexPath.row]
        if section == "账号" && rowTitle == "账号管理" {
            let vc = AccountListViewController()
            navigationController?.pushViewController(vc, animated: true)
        } else if section == "数据" && rowTitle == "分类管理" {
            let vc = CategoryManagerViewController()
            navigationController?.pushViewController(vc, animated: true)
        } else if section == "数据" && rowTitle == "账户管理" {
            let vc = AccountManagerViewController()
            navigationController?.pushViewController(vc, animated: true)
        } else if section == "数据" && rowTitle == "导出数据" {
            exportData()
        } else if section == "其他" && rowTitle == "关于" {
            let alert = UIAlertController(title: "关于", message: "MoneyTracker 记账 v1.0", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "确定", style: .default))
            present(alert, animated: true)
        }
    }

    private func exportData() {
        guard let dao = UserSession.shared.transactionDAO else { return }
        let list = dao.list(limit: 10000)
        var csv = "类型,金额,分类ID,账户ID,备注,日期\n"
        for t in list {
            csv += "\(t.type),\(t.amount),\(t.categoryId),\(t.accountId),\(t.note ?? ""),\(t.date)\n"
        }
        let path = FileManager.default.temporaryDirectory.appendingPathComponent("moneytracker_export.csv")
        try? csv.write(to: path, atomically: true, encoding: .utf8)
        let vc = UIActivityViewController(activityItems: [path], applicationActivities: nil)
        present(vc, animated: true)
    }
}
