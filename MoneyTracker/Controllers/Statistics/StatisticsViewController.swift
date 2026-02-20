//
//  StatisticsViewController.swift
//  MoneyTracker
//

import UIKit
import SnapKit
import Charts

final class StatisticsViewController: UIViewController {

    private let segment: UISegmentedControl = {
        let s = UISegmentedControl(items: ["概览", "分类", "趋势"])
        s.selectedSegmentIndex = 0
        return s
    }()

    private let scrollView: UIScrollView = {
        let s = UIScrollView()
        return s
    }()

    private let contentView = UIView()
    private let incomeLabel = UILabel()
    private let expenseLabel = UILabel()
    private let balanceLabel = UILabel()
    private let chartView = PieChartView()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "统计"
        view.backgroundColor = ColorTheme.background
        view.addSubview(segment)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(incomeLabel)
        contentView.addSubview(expenseLabel)
        contentView.addSubview(balanceLabel)
        contentView.addSubview(chartView)

        segment.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            make.height.equalTo(32)
        }
        scrollView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(segment.snp.bottom).offset(16)
        }
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView)
        }

        incomeLabel.font = FontManager.title3()
        incomeLabel.textColor = ColorTheme.income
        expenseLabel.font = FontManager.title3()
        expenseLabel.textColor = ColorTheme.expense
        balanceLabel.font = FontManager.amountMedium()
        balanceLabel.textColor = ColorTheme.textPrimary

        incomeLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(16)
        }
        expenseLabel.snp.makeConstraints { make in
            make.left.equalTo(incomeLabel)
            make.top.equalTo(incomeLabel.snp.bottom).offset(8)
        }
        balanceLabel.snp.makeConstraints { make in
            make.left.equalTo(incomeLabel)
            make.top.equalTo(expenseLabel.snp.bottom).offset(8)
        }
        chartView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(balanceLabel.snp.bottom).offset(24)
            make.height.equalTo(220)
            make.bottom.equalToSuperview().offset(-24)
        }

        segment.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reload()
    }

    private func reload() {
        let from = DateHelper.toDatabaseString(DateHelper.startOfMonth())
        let to = DateHelper.toDatabaseString(DateHelper.endOfMonth())
        let income = UserSession.shared.transactionDAO?.sumIncome(from: from, to: to) ?? 0
        let expense = UserSession.shared.transactionDAO?.sumExpense(from: from, to: to) ?? 0
        incomeLabel.text = "本月收入：\(String(format: "%.2f", income))"
        expenseLabel.text = "本月支出：\(String(format: "%.2f", expense))"
        balanceLabel.text = "结余：\(String(format: "%.2f", income - expense))"
        updatePieChart(income: income, expense: expense)
    }

    private func updatePieChart(income: Double, expense: Double) {
        var entries: [ChartDataEntry] = []
        if income > 0 { entries.append(PieChartDataEntry(value: income, label: "收入")) }
        if expense > 0 { entries.append(PieChartDataEntry(value: expense, label: "支出")) }
        if entries.isEmpty { entries.append(PieChartDataEntry(value: 1, label: "暂无")) }
        let set = PieChartDataSet(entries: entries)
        set.colors = [ColorTheme.income, ColorTheme.expense]
        chartView.data = PieChartData(dataSet: set)
    }

    @objc private func segmentChanged() {
        // 可扩展：切换概览/分类/趋势不同内容
        reload()
    }
}
