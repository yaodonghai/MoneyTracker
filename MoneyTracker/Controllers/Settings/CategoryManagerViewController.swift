//
//  CategoryManagerViewController.swift
//  MoneyTracker
//

import UIKit
import SnapKit

final class CategoryManagerViewController: UIViewController {

    private var expenseCategories: [Category] = []
    private var incomeCategories: [Category] = []
    private let segment = UISegmentedControl(items: ["支出分类", "收入分类"])
    private let tableView: UITableView = {
        let t = UITableView(frame: .zero, style: .plain)
        t.rowHeight = 48
        return t
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "分类管理"
        view.backgroundColor = ColorTheme.background
        view.addSubview(segment)
        view.addSubview(tableView)
        segment.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.height.equalTo(32)
        }
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(segment.snp.bottom).offset(16)
        }
        segment.selectedSegmentIndex = 0
        segment.addTarget(self, action: #selector(reload), for: .valueChanged)
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reload()
    }

    @objc private func reload() {
        expenseCategories = UserSession.shared.categoryDAO?.all(type: "expense") ?? []
        incomeCategories = UserSession.shared.categoryDAO?.all(type: "income") ?? []
        tableView.reloadData()
    }

    private var currentList: [Category] {
        segment.selectedSegmentIndex == 0 ? expenseCategories : incomeCategories
    }
}

extension CategoryManagerViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { currentList.count }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        let c = currentList[indexPath.row]
        cell.textLabel?.text = c.name
        cell.detailTextLabel?.text = c.isSystem ? "系统" : nil
        return cell
    }
}
