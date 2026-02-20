import UIKit
import SnapKit

class ExampleViewController: UIViewController {
	// MARK: - Properties
	private let theme = ColorTheme()  // Initialize ColorTheme
	private let fontManager = FontManager() // Initialize FontManager
	private let dateHelper = DateHelper() // Initialize DateHelper
	private let userSession = UserSession() // Initialize UserSession
	private let keychainHelper = KeychainHelper() // Initialize KeychainHelper

	private let titleLabel = UILabel()
	private let dateLabel = UILabel()
	
	// MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI() // Setup the UI components
		applyTheme() // Apply color theme
	}
	
	// MARK: - UI Setup
	private func setupUI() {
		view.backgroundColor = theme.backgroundColor  // Set background color from ColorTheme
		
		titleLabel.text = "Example View Controller"
		titleLabel.font = fontManager.titleFont  // Use FontManager for font
		view.addSubview(titleLabel)
		
		dateLabel.text = dateHelper.currentDateString() // Get current date string
		dateLabel.font = fontManager.bodyFont // Use FontManager for body font
		view.addSubview(dateLabel)
		
		// Use SnapKit for Auto Layout
		titleLabel.snp.makeConstraints { make in
			make.centerX.equalToSuperview()
			make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
		}
		
		dateLabel.snp.makeConstraints { make in
			make.centerX.equalToSuperview()
			make.top.equalTo(titleLabel.snp.bottom).offset(20)
		}
	}
	
	// MARK: - Apply Theme
	private func applyTheme() {
		let isDarkMode = traitCollection.userInterfaceStyle == .dark
		view.backgroundColor = isDarkMode ? theme.darkBackgroundColor : theme.lightBackgroundColor
	}
	
	// MARK: - User Session Management
	private func fetchUserSession() {
		if let user = userSession.currentUser() {
			keychainHelper.save(key: "userToken", value: user.token) // Save user token in Keychain
		}
	}
}