//
//  HomeViewController.swift
//  MoneyTracker
//

import UIKit
import SnapKit

final class HomeViewController: UIViewController {

    private let overviewCard: UIView = {
        let v = UIView()
        v.backgroundColor = ColorTheme.cardBackground
        v.layer.cornerRadius = 12
        return v
    }()

    private let monthLabel: UILabel = {
        let l = UILabel()
        l.font = FontManager.title3()
        l.textColor = ColorTheme.textSecondary
        return l
    }()

    private let incomeLabel: UILabel = {
        let l = UILabel()
        l.font = FontManager.footnote()
        l.textColor = ColorTheme.textSecondary
        l.text = "收入"
        return l
    }()

    private let incomeValueLabel: UILabel = {
        let l = UILabel()
        l.font = FontManager.amountMedium()
        l.textColor = ColorTheme.income
        l.text = "0.00"
        return l
    }()

    private let expenseLabel: UILabel = {
        let l = UILabel()
        l.font = FontManager.footnote()
        l.textColor = ColorTheme.textSecondary
        l.text = "支出"
        return l
    }()

    private let expenseValueLabel: UILabel = {
        let l = UILabel()
        l.font = FontManager.amountMedium()
        l.textColor = ColorTheme.expense
        l.text = "0.00"
        return l
    }()

    private let addButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("记一笔", for: .normal)
        b.titleLabel?.font = FontManager.title3()
        b.backgroundColor = ColorTheme.primary
        b.setTitleColor(.white, for: .normal)
        b.layer.cornerRadius = 25
        return b
    }()

    private let recentLabel: UILabel = {
        let l = UILabel()
        l.text = "最近记录"
        l.font = FontManager.title3()
        l.textColor = ColorTheme.textPrimary
        return l
    }()

    private let tableView: UITableView = {
        let t = UITableView(frame: .zero, style: .plain)
        t.rowHeight = 56
        t.tableFooterView = UIView()
        return t
    }()

    private var recentList: [Transaction] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "首页"
        view.backgroundColor = ColorTheme.background
        monthLabel.text = DateHelper.displayMonth(Date())

        view.addSubview(overviewCard)
        overviewCard.addSubview(monthLabel)
        overviewCard.addSubview(incomeLabel)
        overviewCard.addSubview(incomeValueLabel)
        overviewCard.addSubview(expenseLabel)
        overviewCard.addSubview(expenseValueLabel)
        view.addSubview(addButton)
        view.addSubview(recentLabel)
        view.addSubview(tableView)

        overviewCard.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.height.equalTo(100)
        }
        monthLabel.snp.makeConstraints { make in
            make.left.top.equalToSuperview().offset(16)
        }
        incomeLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalTo(monthLabel.snp.bottom).offset(12)
        }
        incomeValueLabel.snp.makeConstraints { make in
            make.left.equalTo(incomeLabel.snp.right).offset(8)
            make.centerY.equalTo(incomeLabel)
        }
        expenseLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalTo(incomeLabel.snp.bottom).offset(8)
        }
        expenseValueLabel.snp.makeConstraints { make in
            make.left.equalTo(expenseLabel.snp.right).offset(8)
            make.centerY.equalTo(expenseLabel)
        }
        addButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(overviewCard.snp.bottom).offset(24)
            make.width.equalTo(160)
            make.height.equalTo(50)
        }
        recentLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalTo(addButton.snp.bottom).offset(24)
        }
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(recentLabel.snp.bottom).offset(8)
        }

        addButton.addTarget(self, action: #selector(openAddTransaction), for: .touchUpInside)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TransactionCell.self, forCellReuseIdentifier: TransactionCell.reuseId)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadData()
    }

    private func reloadData() {
        let from = DateHelper.toDatabaseString(DateHelper.startOfMonth())
        let to = DateHelper.toDatabaseString(DateHelper.endOfMonth())
        let income = UserSession.shared.transactionDAO?.sumIncome(from: from, to: to) ?? 0
        let expense = UserSession.shared.transactionDAO?.sumExpense(from: from, to: to) ?? 0
        incomeValueLabel.text = String(format: "%.2f", income)
        expenseValueLabel.text = String(format: "%.2f", expense)
        recentList = UserSession.shared.transactionDAO?.recent(limit: 5) ?? []
        tableView.reloadData()
    }

    @objc private func openAddTransaction() {
        let vc = AddTransactionViewController()
        vc.onSaved = { [weak self] in self?.reloadData() }
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        recentList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TransactionCell.reuseId, for: indexPath) as! TransactionCell
        cell.configure(recentList[indexPath.row], categoryDAO: UserSession.shared.categoryDAO, accountDAO: UserSession.shared.accountDAO)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
