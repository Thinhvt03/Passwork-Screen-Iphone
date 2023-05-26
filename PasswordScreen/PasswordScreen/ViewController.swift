//  ViewController.swift
//  PasswordScreen

import UIKit

extension UIViewController {
    enum Alert {
        case createPasscode
        case confirmPasscode
        case enterPasscode
        
        var name: String {
            switch self {
            case .createPasscode:
                return "Create your password"
            case .confirmPasscode:
                return "Confirm your password"
            case .enterPasscode:
                return "Enter your password"
            }
        }
        
        var messages: String? {
            switch self {
            case .createPasscode:
                return nil
            case .confirmPasscode:
                return "Password is not match."
            case .enterPasscode:
                return "Password is incorrect."
            }
        }
    }
    
    // Set alert
    func alert(_ title: String, message: String = "") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default)
        alert.addAction(ok)
        present(alert, animated: true)
    }
}

class ViewController: UIViewController {
    @IBOutlet weak var passcodeFieldsStackView: UIStackView!
    @IBOutlet weak var stackViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var statusLabel: UILabel!
    
    private var viewsArray: [SecureView] = []
    private let animationDuration: CGFloat = 0.25
    private let animationDelay: CGFloat = 0.1
    private let passcodeLength: Int = 4
    private var passcode: String = ""
    private var temporary: String = ""
    private var input: String = ""
    private let userDefaults = UserDefaults.standard
    
    enum Keys {
        static let passcode = "passcode"
    }
    
    // MARK: - Lifecycle View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passcode = userDefaults.string(forKey: Keys.passcode) ?? ""
        setupViews()
        if passcode == "" {
            statusLabel.text = Alert.createPasscode.name
        } else {
            statusLabel.text = Alert.enterPasscode.name
        }
    }
    
    func setupViews() {
        for _ in 0..<passcodeLength {
            let secureView = SecureView()
            viewsArray.append(secureView)
            passcodeFieldsStackView.addArrangedSubview(secureView)
        }
        let secureView = SecureView()
        stackViewWidthConstraint.constant = secureView.backgroundWidthConstraint * CGFloat(passcodeLength)
    }
    
    // ProgressView has animation .
    func progressView(completion: @escaping () -> Void) {
        UIView.animate(withDuration: animationDuration, delay: animationDelay ) {
            self.view.layoutIfNeeded()
            
            // index of viewsArray start index = 0, need to set input.count - 1
            self.viewsArray[self.input.count - 1].setViewsWhenEnterPasscode()
        } completion: { _ in
            for secureView in self.viewsArray {
                secureView.isShowBackgoundView = true
            }
            completion()
        }
    }
    
    func progressPasscodeFieldsViews() {
        for secureView in self.viewsArray {
            secureView.progressPasscodeFieldsView()
        }
    }

    @IBAction func buttonPressed(_ sender: UIButton) {
        guard self.input.count < passcodeLength else { return }
        if sender.tag >= 0 {
            input += String(sender.tag)
        }
        print(input)
        
            self.progressView {
            guard self.input.count == self.passcodeLength else { return }
            if !self.passcode.isEmpty {
                if self.input == self.passcode {
                    self.showMainScreen()
                } else {
                    self.alert(Alert.enterPasscode.messages!)
                    self.progressPasscodeFieldsViews()
                }
            }
            else if self.temporary.isEmpty {
                self.temporary = self.input
                self.statusLabel.text = Alert.confirmPasscode.name
                self.progressPasscodeFieldsViews()
            } else {
                if self.input == self.temporary {
                    self.userDefaults.set(self.input, forKey: Keys.passcode)
                    self.showMainScreen()
                } else {
                    self.progressPasscodeFieldsViews()
                    self.alert(Alert.confirmPasscode.messages!)
                    self.statusLabel.text = Alert.createPasscode.name
                    self.temporary = ""
                }
            }
            self.input = ""
        }
    }
    
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        if sender.tag == -2, input.count != 0 {
            input.removeLast()
            print(input)
        }
        self.viewsArray[input.count].isPasscodeViewColor = false
    }
    
    @IBAction func buttonDeleteAll(_ sender: UIButton) {
        if sender.tag == -1, input.count != 0 {
            input.removeAll()
            print(input)
        }
        self.progressPasscodeFieldsViews()
    }
    
    // Show main screen
    private func showMainScreen() {
        UIView.animate(withDuration: animationDuration,delay: 0) {
            self.view.layoutIfNeeded()
        } completion: { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                let vcMain = MainViewController()
                let navigation = UINavigationController(rootViewController: vcMain)
                self.view.addSubview(navigation.view)
            }
        }
    }
}

// MARK: - Setup Number Button

class NumberButton: UIButton {
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? .darkGray : .black
            layer.cornerRadius = isHighlighted ? self.bounds.width / 2 : 0
        }
    }
}
