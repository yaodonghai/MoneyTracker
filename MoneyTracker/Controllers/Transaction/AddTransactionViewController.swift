//
//  AddTransactionViewController.swift
//  MoneyTracker
//

import UIKit
import SnapKit
import MBProgressHUD

final class AddTransactionViewController: UIViewController {

    var onSaved: (() -> Void)?

    private var isIncome = false  // 默认支出
    private var selectedCategoryId: Int64?
    private var selectedAccountId: Int64?
    private var selectedDate = Date()
    private var amountText = ""

    private let segment: UISegmentedControl = {
        let s = UISegmentedControl(items: ["支出", "收入"])
        s.selectedSegmentIndex = 0  // 默认选中支出
        return s
    }()

    private let amountLabel: UILabel = {
        let l = UILabel()
        l.font = FontManager.amountLarge()
        l.textColor = ColorTheme.textPrimary
        l.text = "0.00"
        l.textAlignment = .center
        return l
    }()

    private let categoryButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("选择分类", for: .normal)
        b.contentHorizontalAlignment = .left
        b.setTitleColor(ColorTheme.textPrimary, for: .normal)
        return b
    }()

    private let accountButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("选择账户", for: .normal)
        b.contentHorizontalAlignment = .left
        b.setTitleColor(ColorTheme.textPrimary, for: .normal)
        return b
    }()

    private let dateButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitleColor(ColorTheme.textPrimary, for: .normal)
        return b
    }()

    private let noteField: UITextField = {
        let t = UITextField()
        t.placeholder = "备注（选填）"
        t.borderStyle = .roundedRect
        t.backgroundColor = ColorTheme.cardBackground
        return t
    }()

    private let saveButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("保存", for: .normal)
        b.titleLabel?.font = FontManager.title3()
        b.backgroundColor = ColorTheme.primary
        b.setTitleColor(.white, for: .normal)
        b.layer.cornerRadius = 10
        return b
    }()

    private let numPadContainer = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "记一笔"
        view.backgroundColor = ColorTheme.background
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(cancel))
        updateDateTitle()
        
        // 添加点击空白处收起键盘的手势
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)

        view.addSubview(segment)
        view.addSubview(amountLabel)
        view.addSubview(categoryButton)
        view.addSubview(accountButton)
        view.addSubview(dateButton)
        view.addSubview(noteField)
        view.addSubview(saveButton)
        view.addSubview(numPadContainer)
        buildNumPad()

        segment.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.width.equalTo(200)
            make.height.equalTo(32)
        }
        amountLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(segment.snp.bottom).offset(24)
        }
        categoryButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(amountLabel.snp.bottom).offset(24)
            make.height.equalTo(44)
        }
        accountButton.snp.makeConstraints { make in
            make.left.right.height.equalTo(categoryButton)
            make.top.equalTo(categoryButton.snp.bottom).offset(8)
        }
        dateButton.snp.makeConstraints { make in
            make.left.right.height.equalTo(categoryButton)
            make.top.equalTo(accountButton.snp.bottom).offset(8)
        }
        noteField.snp.makeConstraints { make in
            make.left.right.equalTo(categoryButton)
            make.top.equalTo(dateButton.snp.bottom).offset(8)
            make.height.equalTo(44)
        }
        saveButton.snp.makeConstraints { make in
            make.left.right.equalTo(categoryButton)
            make.top.equalTo(noteField.snp.bottom).offset(24)
            make.height.equalTo(48)
        }
        numPadContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(260)
        }

        segment.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        categoryButton.addTarget(self, action: #selector(pickCategory), for: .touchUpInside)
        accountButton.addTarget(self, action: #selector(pickAccount), for: .touchUpInside)
        dateButton.addTarget(self, action: #selector(pickDate), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(save), for: .touchUpInside)
    }

    private func buildNumPad() {
        let row1 = ["1", "2", "3"]
        let row2 = ["4", "5", "6"]
        let row3 = ["7", "8", "9"]
        let row4 = [".", "0", "⌫"]
        let rows = [row1, row2, row3, row4]
        let h: CGFloat = 44
        let gap: CGFloat = 8
        for (rowIndex, row) in rows.enumerated() {
            for (colIndex, title) in row.enumerated() {
                let b = UIButton(type: .system)
                b.setTitle(title, for: .normal)
                b.setTitleColor(ColorTheme.textPrimary, for: .normal)
                b.titleLabel?.font = FontManager.title3()
                b.backgroundColor = ColorTheme.secondaryBackground
                b.layer.cornerRadius = 8
                if title == "⌫" {
                    b.addTarget(self, action: #selector(backspace), for: .touchUpInside)
                } else {
                    b.addTarget(self, action: #selector(numTapped(_:)), for: .touchUpInside)
                }
                numPadContainer.addSubview(b)
                let x = 16 + CGFloat(colIndex) * (UIScreen.main.bounds.width / 3 - 16 / 3)
                let y = CGFloat(rowIndex) * (h + gap) + gap
                b.frame = CGRect(x: x, y: y, width: (UIScreen.main.bounds.width - 32) / 3 - gap, height: h)
            }
        }
    }

    @objc private func numTapped(_ sender: UIButton) {
        guard let s = sender.title(for: .normal) else { return }
        if s == "." {
            if amountText.contains(".") { return }
            if amountText.isEmpty { amountText = "0" }
        }
        if amountText == "0" && s != "." { amountText = "" }
        amountText += s
        updateAmountDisplay()
    }

    @objc private func backspace() {
        if !amountText.isEmpty { amountText.removeLast() }
        updateAmountDisplay()
    }

    private func updateAmountDisplay() {
        if amountText.isEmpty { amountLabel.text = "0.00" }
        else { amountLabel.text = amountText }
    }

    private func updateDateTitle() {
        dateButton.setTitle(DateHelper.displayDate(selectedDate), for: .normal)
    }

    @objc private func segmentChanged() {
        isIncome = segment.selectedSegmentIndex == 1
        selectedCategoryId = nil
        categoryButton.setTitle("选择分类", for: .normal)
    }

    @objc private func cancel() {
        view.endEditing(true)
        dismiss(animated: true)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc private func pickCategory() {
        let list = UserSession.shared.categoryDAO?.all(type: isIncome ? "income" : "expense") ?? []
        let vc = ListPickerViewController(
            title: "选择分类",
            items: list.map { ($0.id, $0.name) },
            selectedId: selectedCategoryId
        ) { [weak self] id in
            self?.selectedCategoryId = id
            self?.categoryButton.setTitle(list.first(where: { $0.id == id })?.name ?? "选择分类", for: .normal)
        }
        present(UINavigationController(rootViewController: vc), animated: true)
    }

    @objc private func pickAccount() {
        let list = UserSession.shared.accountDAO?.all() ?? []
        let vc = ListPickerViewController(
            title: "选择账户",
            items: list.map { ($0.id, "\($0.name)  \(String(format: "%.2f", $0.balance))") },
            selectedId: selectedAccountId
        ) { [weak self] id in
            self?.selectedAccountId = id
            if let acc = list.first(where: { $0.id == id }) {
                self?.accountButton.setTitle("\(acc.name)  \(String(format: "%.2f", acc.balance))", for: .normal)
            }
        }
        present(UINavigationController(rootViewController: vc), animated: true)
    }

    @objc private func pickDate() {
        let picker = UIDatePicker()
        picker.datePickerMode = .dateAndTime
        picker.date = selectedDate
        picker.maximumDate = Date()
        let alert = UIAlertController(title: "选择日期", message: nil, preferredStyle: .actionSheet)
        let vc = UIViewController()
        vc.view.addSubview(picker)
        picker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            picker.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor),
            picker.topAnchor.constraint(equalTo: vc.view.topAnchor),
            picker.bottomAnchor.constraint(equalTo: vc.view.bottomAnchor)
        ])
        alert.setValue(vc, forKey: "contentViewController")
        alert.addAction(UIAlertAction(title: "确定", style: .default) { [weak self] _ in
            self?.selectedDate = picker.date
            self?.updateDateTitle()
        })
        alert.addAction(UIAlertAction(title: "取消", style: .cancel))
        present(alert, animated: true)
    }

    @objc private func save() {
        // 收起键盘
        view.endEditing(true)
        
        // 验证金额
        let amount: Double
        if amountText.isEmpty { 
            showAlert("请输入金额")
            return 
        } else { 
            amount = Double(amountText) ?? 0 
        }
        guard amount > 0 else { 
            showAlert("金额必须大于0")
            return 
        }
        
        // 验证分类
        guard let catId = selectedCategoryId else { 
            showAlert("请选择分类")
            return 
        }
        
        // 验证账户
        guard let accId = selectedAccountId else { 
            showAlert("请选择账户")
            return 
        }
        
        // 检查 DAO 是否存在
        guard let transactionDAO = UserSession.shared.transactionDAO else {
            showAlert("数据库错误，请重新登录")
            return
        }
        
        let dateStr = DateHelper.toDatabaseString(selectedDate)
        let note = noteField.text?.trimmed
        
        // 保存记账记录
        guard let transactionId = transactionDAO.insert(
            type: isIncome ? "income" : "expense", 
            amount: amount, 
            categoryId: catId, 
            accountId: accId, 
            note: note, 
            date: dateStr
        ) else {
            showAlert("保存失败，请重试")
            return
        }
        
        // 更新账户余额
        if let dao = UserSession.shared.accountDAO, let acc = dao.find(id: accId) {
            let newBalance = acc.balance + (isIncome ? amount : -amount)
            let success = dao.updateBalance(accountId: accId, newBalance: newBalance)
            if !success {
                print("警告：更新账户余额失败")
            }
        }
        
        // 保存成功，显示提示并关闭页面
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.mode = .text
        hud.label.text = "保存成功"
        hud.hide(animated: true, afterDelay: 0.5)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.dismiss(animated: true) { 
                self?.onSaved?() 
            }
        }
    }
    
    private func showAlert(_ message: String) {
        let alert = UIAlertController(title: "提示", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default))
        present(alert, animated: true)
    }
}
