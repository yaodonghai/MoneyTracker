//
//  RegisterViewController.swift
//  MoneyTracker
//

import UIKit
import SnapKit

final class RegisterViewController: UIViewController {

    var onSuccess: (() -> Void)?

    private let titleLabel: UILabel = {
        let l = UILabel()
        l.text = "注册"
        l.font = FontManager.largeTitle()
        l.textColor = ColorTheme.textPrimary
        return l
    }()

    private let usernameField: UITextField = {
        let t = UITextField()
        t.placeholder = "用户名"
        t.borderStyle = .roundedRect
        t.autocapitalizationType = .none
        t.backgroundColor = ColorTheme.cardBackground
        return t
    }()

    private let passwordField: UITextField = {
        let t = UITextField()
        t.placeholder = "密码（至少6位）"
        t.borderStyle = .roundedRect
        t.isSecureTextEntry = true
        t.backgroundColor = ColorTheme.cardBackground
        return t
    }()

    private let confirmField: UITextField = {
        let t = UITextField()
        t.placeholder = "确认密码"
        t.borderStyle = .roundedRect
        t.isSecureTextEntry = true
        t.backgroundColor = ColorTheme.cardBackground
        return t
    }()

    private let registerButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("注册", for: .normal)
        b.titleLabel?.font = FontManager.title3()
        b.backgroundColor = ColorTheme.primary
        b.setTitleColor(.white, for: .normal)
        b.layer.cornerRadius = 10
        return b
    }()

    private let messageLabel: UILabel = {
        let l = UILabel()
        l.font = FontManager.footnote()
        l.textColor = ColorTheme.expense
        l.numberOfLines = 0
        l.textAlignment = .center
        return l
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorTheme.background
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(close))

        view.addSubview(titleLabel)
        view.addSubview(usernameField)
        view.addSubview(passwordField)
        view.addSubview(confirmField)
        view.addSubview(registerButton)
        view.addSubview(messageLabel)

        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(60)
        }
        usernameField.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(32)
            make.right.equalToSuperview().offset(-32)
            make.top.equalTo(titleLabel.snp.bottom).offset(40)
            make.height.equalTo(44)
        }
        passwordField.snp.makeConstraints { make in
            make.left.right.height.equalTo(usernameField)
            make.top.equalTo(usernameField.snp.bottom).offset(16)
        }
        confirmField.snp.makeConstraints { make in
            make.left.right.height.equalTo(usernameField)
            make.top.equalTo(passwordField.snp.bottom).offset(16)
        }
        registerButton.snp.makeConstraints { make in
            make.left.right.equalTo(usernameField)
            make.top.equalTo(confirmField.snp.bottom).offset(32)
            make.height.equalTo(48)
        }
        messageLabel.snp.makeConstraints { make in
            make.left.right.equalTo(usernameField)
            make.top.equalTo(registerButton.snp.bottom).offset(16)
        }

        registerButton.addTarget(self, action: #selector(doRegister), for: .touchUpInside)
    }

    @objc private func close() {
        dismiss(animated: true)
    }

    @objc private func doRegister() {
        messageLabel.text = ""
        let username = usernameField.text?.trimmed ?? ""
        let password = passwordField.text ?? ""
        let confirm = confirmField.text ?? ""
        guard !username.isEmpty else { messageLabel.text = "请输入用户名"; return }
        guard !password.isEmpty else { messageLabel.text = "请输入密码"; return }
        guard password == confirm else { messageLabel.text = "两次密码不一致"; return }

        let result = UserSession.shared.register(username: username, password: password)
        if result.success {
            KeychainHelper.lastUsername = username
            dismiss(animated: true) { [weak self] in
                self?.onSuccess?()
            }
        } else {
            messageLabel.text = result.message
        }
    }
}
