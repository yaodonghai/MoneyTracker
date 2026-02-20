//
//  TransactionCell.swift
//  MoneyTracker
//

import UIKit
import SnapKit

final class TransactionCell: UITableViewCell {

    static let reuseId = "TransactionCell"

    private let typeLabel: UILabel = {
        let l = UILabel()
        l.font = FontManager.callout()
        l.textColor = ColorTheme.textPrimary
        return l
    }()

    private let dateLabel: UILabel = {
        let l = UILabel()
        l.font = FontManager.footnote()
        l.textColor = ColorTheme.textSecondary
        return l
    }()

    private let amountLabel: UILabel = {
        let l = UILabel()
        l.font = FontManager.callout(weight: .medium)
        return l
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(typeLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(amountLabel)
        typeLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(8)
        }
        dateLabel.snp.makeConstraints { make in
            make.left.equalTo(typeLabel)
            make.top.equalTo(typeLabel.snp.bottom).offset(4)
        }
        amountLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func configure(_ t: Transaction, categoryDAO: CategoryDAO?, accountDAO: AccountDAO?) {
        let categoryName = categoryDAO?.find(id: t.categoryId)?.name ?? ""
        typeLabel.text = categoryName.isEmpty ? (t.isIncome ? "收入" : "支出") : categoryName
        dateLabel.text = DateHelper.fromDatabaseString(t.date).map { DateHelper.displayShort($0) } ?? t.date
        amountLabel.text = (t.isIncome ? "+" : "-") + String(format: "%.2f", t.amount)
        amountLabel.textColor = t.isIncome ? ColorTheme.income : ColorTheme.expense
    }
}
