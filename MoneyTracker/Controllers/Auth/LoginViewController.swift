//
//  LoginViewController.swift
//  MoneyTracker
//

import UIKit
import SnapKit

final class LoginViewController: UIViewController {

    private let titleLabel: UILabel = {
        let l = UILabel()
        l.text = "记账"
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
        t.placeholder = "密码"
        t.borderStyle = .roundedRect
        t.isSecureTextEntry = true
        t.backgroundColor = ColorTheme.cardBackground
        return t
    }()

    private let loginButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("登录", for: .normal)
        b.titleLabel?.font = FontManager.title3()
        b.backgroundColor = ColorTheme.primary
        b.setTitleColor(.white, for: .normal)
        b.layer.cornerRadius = 10
        return b
    }()

    private let registerButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("没有账号？注册", for: .normal)
        b.setTitleColor(ColorTheme.primary, for: .normal)
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
        usernameField.text = KeychainHelper.lastUsername

        view.addSubview(titleLabel)
        view.addSubview(usernameField)
        view.addSubview(passwordField)
        view.addSubview(loginButton)
        view.addSubview(registerButton)
        view.addSubview(messageLabel)

        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(80)
        }
        usernameField.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(32)
            make.right.equalToSuperview().offset(-32)
            make.top.equalTo(titleLabel.snp.bottom).offset(48)
            make.height.equalTo(44)
        }
        passwordField.snp.makeConstraints { make in
            make.left.right.height.equalTo(usernameField)
            make.top.equalTo(usernameField.snp.bottom).offset(16)
        }
        loginButton.snp.makeConstraints { make in
            make.left.right.equalTo(usernameField)
            make.top.equalTo(passwordField.snp.bottom).offset(32)
            make.height.equalTo(48)
        }
        registerButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(loginButton.snp.bottom).offset(24)
        }
        messageLabel.snp.makeConstraints { make in
            make.left.right.equalTo(usernameField)
            make.top.equalTo(registerButton.snp.bottom).offset(16)
        }

        loginButton.addTarget(self, action: #selector(doLogin), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(goRegister), for: .touchUpInside)
    }

    @objc private func doLogin() {
        messageLabel.text = ""
        let username = usernameField.text?.trimmed ?? ""
        let password = passwordField.text ?? ""
        guard !username.isEmpty else { messageLabel.text = "请输入用户名"; return }
        guard !password.isEmpty else { messageLabel.text = "请输入密码"; return }

        if UserSession.shared.login(username: username, password: password) {
            KeychainHelper.lastUsername = username
            showMainApp()
        } else {
            messageLabel.text = "用户名或密码错误"
        }
    }

    @objc private func goRegister() {
        let vc = RegisterViewController()
        vc.onSuccess = { [weak self] in
            self?.showMainApp()
        }
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }

    private func showMainApp() {
        guard let window = view.window else { return }
        window.rootViewController = MainTabBarController()
    }
}
