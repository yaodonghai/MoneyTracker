//
//  TransactionDetailViewController.swift
//  MoneyTracker
//

import UIKit
import SnapKit

final class TransactionDetailViewController: UIViewController {

    private let transaction: Transaction
    var onDeleted: (() -> Void)?

    private let amountLabel: UILabel = {
        let l = UILabel()
        l.font = FontManager.amountLarge()
        l.textAlignment = .center
        return l
    }()

    private let stack: UIStackView = {
        let s = UIStackView()
        s.axis = .vertical
        s.spacing = 12
        return s
    }()

    init(transaction: Transaction) {
        self.transaction = transaction
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "账单详情"
        view.backgroundColor = ColorTheme.background
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "删除", style: .plain, target: self, action: #selector(deleteTapped))
        navigationItem.rightBarButtonItem?.tintColor = ColorTheme.expense

        let cat = UserSession.shared.categoryDAO?.find(id: transaction.categoryId)
        let acc = UserSession.shared.accountDAO?.find(id: transaction.accountId)
        amountLabel.text = (transaction.isIncome ? "+" : "-") + String(format: "%.2f", transaction.amount)
        amountLabel.textColor = transaction.isIncome ? ColorTheme.income : ColorTheme.expense

        addRow("类型", transaction.isIncome ? "收入" : "支出")
        addRow("分类", cat?.name ?? "")
        addRow("账户", acc?.name ?? "")
        addRow("日期", DateHelper.fromDatabaseString(transaction.date).map { DateHelper.displayDate($0) } ?? transaction.date)
        if let note = transaction.note, !note.isEmpty { addRow("备注", note) }

        view.addSubview(amountLabel)
        view.addSubview(stack)
        amountLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(24)
        }
        stack.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(amountLabel.snp.bottom).offset(24)
        }

        let editBtn = UIBarButtonItem(title: "编辑", style: .plain, target: self, action: #selector(editTapped))
        navigationItem.rightBarButtonItems = [navigationItem.rightBarButtonItem!, editBtn]
    }

    private func addRow(_ title: String, _ value: String) {
        let row = UILabel()
        row.font = FontManager.callout()
        row.textColor = ColorTheme.textSecondary
        row.text = "\(title)：\(value)"
        stack.addArrangedSubview(row)
    }

    @objc private func editTapped() {
        let vc = AddTransactionViewController()
        vc.onSaved = { [weak self] in
            self?.onDeleted?()
            self?.navigationController?.popViewController(animated: true)
        }
        // 可扩展为编辑模式：预填 amount/category/account/date/note
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc private func deleteTapped() {
        let alert = UIAlertController(title: "删除", message: "确定删除这条记录？", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "取消", style: .cancel))
        alert.addAction(UIAlertAction(title: "删除", style: .destructive) { [weak self] _ in
            guard let t = self?.transaction else { return }
            _ = UserSession.shared.transactionDAO?.delete(id: t.id)
            self?.onDeleted?()
            self?.navigationController?.popViewController(animated: true)
        })
        present(alert, animated: true)
    }
}
