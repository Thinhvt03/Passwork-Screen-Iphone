
//  ViewController.swift
//  PasswordScreen

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var passcodeFieldsStackView: UIStackView!
    @IBOutlet weak var firstBackgroundView: UIView!
    @IBOutlet weak var secondBackgroundView: UIView!
    @IBOutlet weak var thirdBackgroundView: UIView!
    @IBOutlet weak var fourthBackgroundView: UIView!
    @IBOutlet weak var firstPasscodeView: UIView!
    @IBOutlet weak var secondPasscodeView: UIView!
    @IBOutlet weak var thirdPasscodeView: UIView!
    @IBOutlet weak var fourthPasscodeView: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    
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
    
    struct Titles {
        static let enterPasscode = "Enter your password"
        static let createPasscode = "Create your password "
        static let confirmPasscode = "Confirm your password"
    }
    
    struct Messages {
        static let notMatch = "Password is not match."
        static let incorrect = "Password is incorrect."
    }
    
    // MARK: - Lifecycle View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passcode = userDefaults.string(forKey: Keys.passcode) ?? ""
        initialSetupViews()
        if passcode == "" {
            statusLabel.text = Titles.createPasscode
        } else {
            statusLabel.text = Titles.enterPasscode
        }
    }
    
    private func initialSetupViews() {
        let backgroundViewArray = [firstBackgroundView, secondBackgroundView, thirdBackgroundView, fourthBackgroundView]
        for subView in backgroundViewArray {
            subView?.backgroundColor = .darkGray
            subView?.layer.cornerRadius = subView!.bounds.width / 2
            subView?.isHidden = true
        }
        
        let passcodeViewArray = [firstPasscodeView, secondPasscodeView, thirdPasscodeView, fourthPasscodeView]
        for passcodeView in passcodeViewArray {
            passcodeView?.backgroundColor = .darkGray
            passcodeView?.layer.borderWidth = 1
            passcodeView?.layer.borderColor = CGColor(red: 1, green: 1, blue: 1, alpha: 1)
            passcodeView?.layer.cornerRadius = passcodeView!.bounds.width / 2
        }
    }
    
    // Setup passcode view while enter password.
    func setupPasscodeViews() {
        switch input.count {
        case 1:
            firstPasscodeView.backgroundColor = .white
            firstBackgroundView.isHidden = false
        case 2:
            secondPasscodeView.backgroundColor = .white
            secondBackgroundView.isHidden = false
        case 3:
            thirdPasscodeView.backgroundColor = .white
            thirdBackgroundView.isHidden = false
        case 4:
            fourthPasscodeView.backgroundColor = .white
            fourthBackgroundView.isHidden = false
        default:
            print("No handle")
        }
    }
    
    // ProgressView has animation .
    private func progressView(completion: @escaping () -> Void) {
        UIView.animate(withDuration: animationDuration, delay: animationDelay ) {
            self.view.layoutIfNeeded()
            self.setupPasscodeViews()
        } completion: { _ in
            self.firstBackgroundView.isHidden = true
            self.secondBackgroundView.isHidden = true
            self.thirdBackgroundView.isHidden = true
            self.fourthBackgroundView.isHidden = true
            completion()
        }
    }
    
    // Set up alert
    private func alert(_ title: String, message: String = "") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default)
        alert.addAction(ok)
        present(alert, animated: true)
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        guard self.input.count < passcodeLength else { return }
        if sender.tag >= 0 {
            input += String(sender.tag)
        }
        print(input)
        
        progressView {
            guard self.input.count == self.passcodeLength else { return }
            if !self.passcode.isEmpty {
                if self.input == self.passcode {
                    self.showMainScreen()
                } else {
                    self.alert(Messages.incorrect)
                    self.progressPasscodeFieldsView()
                }
            }
            else if self.temporary.isEmpty {
                self.temporary = self.input
                self.statusLabel.text = Titles.confirmPasscode
                self.progressPasscodeFieldsView()
            } else {
                if self.input == self.temporary {
                    self.userDefaults.set(self.input, forKey: Keys.passcode)
                    self.showMainScreen()
                } else {
                    self.progressPasscodeFieldsView()
                    self.alert(Messages.notMatch)
                    self.statusLabel.text = Titles.createPasscode
                    self.temporary = ""
                }
            }
            self.input = ""
        }
    }
    
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        if sender.tag == -2 {
            input.removeLast()
            print(input)
        }
        switch input.count + 1 {
        case 1:
            firstPasscodeView.backgroundColor = .darkGray
        case 2:
            secondPasscodeView.backgroundColor = .darkGray
        case 3:
            thirdPasscodeView.backgroundColor = .darkGray
        case 4:
            fourthPasscodeView.backgroundColor = .darkGray
        default:
            print("No handle")
        }
    }
    
    @IBAction func buttonDeleteAll(_ sender: UIButton) {
        if sender.tag == -1 {
            input.removeAll()
            print(input)
        }
        progressPasscodeFieldsView()
    }
    
    private func progressPasscodeFieldsView() {
        UIView.animate(withDuration: animationDuration, delay: animationDelay) {
        } completion: { _ in
            self.firstPasscodeView.backgroundColor = .darkGray
            self.secondPasscodeView.backgroundColor = .darkGray
            self.thirdPasscodeView.backgroundColor = .darkGray
            self.fourthPasscodeView.backgroundColor = .darkGray
        }
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
