//
//  ListPickerViewController.swift
//  MoneyTracker
//

import UIKit
import SnapKit

final class ListPickerViewController: UIViewController {

    private let titleText: String
    private let items: [(id: Int64, title: String)]
    private let selectedId: Int64?
    private let onSelect: (Int64) -> Void

    private let tableView: UITableView = {
        let t = UITableView(frame: .zero, style: .plain)
        t.rowHeight = 48
        return t
    }()

    init(title: String, items: [(id: Int64, title: String)], selectedId: Int64?, onSelect: @escaping (Int64) -> Void) {
        self.titleText = title
        self.items = items
        self.selectedId = selectedId
        self.onSelect = onSelect
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = titleText
        view.backgroundColor = ColorTheme.background
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(close))
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in make.edges.equalToSuperview() }
        tableView.delegate = self
        tableView.dataSource = self
    }

    @objc private func close() {
        dismiss(animated: true)
    }
}

extension ListPickerViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { items.count }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        let item = items[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.id == selectedId ? .checkmark : .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onSelect(items[indexPath.row].id)
        dismiss(animated: true)
    }
}
