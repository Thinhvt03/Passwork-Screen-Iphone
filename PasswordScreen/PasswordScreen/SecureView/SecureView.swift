import UIKit

class SecureView: UIView {

    @IBOutlet private weak var backgroundView: UIView!
    @IBOutlet private weak var passcodeView: UIView!
    
    let nibNamed = "SecureView"
    
    public var backgroundWidthConstraint: CGFloat {
        return backgroundView.frame.width
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .black
        initSubView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initSubView() {
        let nib = Bundle.main.loadNibNamed(nibNamed, owner: self)?.first as! UIView
        nib.frame = self.bounds
        addSubview(nib)
        
        // backgroundView
        backgroundView.backgroundColor = .darkGray
        backgroundView.layer.cornerRadius = backgroundView.bounds.width / 2
        backgroundView.isHidden = true
        
        // PasscodeView
        passcodeView.backgroundColor = .darkGray
        passcodeView.layer.borderWidth = 1
        passcodeView.layer.borderColor = CGColor(red: 1, green: 1, blue: 1, alpha: 1)
        passcodeView.layer.cornerRadius = passcodeView.bounds.width / 2
        
    }
    
    var isShowBackgoundView: Bool = true {
        didSet {
            backgroundView.isHidden = isShowBackgoundView ? true : false
        }
    }
    
    var isBackgoundViewColor: Bool = false {
        didSet {
            backgroundView.backgroundColor = isBackgoundViewColor ? .white : .darkGray
        }
    }
    
    var isPasscodeViewColor: Bool = false {
        didSet {
            passcodeView.backgroundColor = isPasscodeViewColor ? .white : .darkGray
        }
    }
    
    func setViewsWhenEnterPasscode() {
        passcodeView.backgroundColor = .white
        self.isShowBackgoundView = false
    }
    
    func progressPasscodeFieldsView() {
        UIView.animate(withDuration: 0.25, delay: 0.1) {
        } completion: { _ in
            self.isPasscodeViewColor = false
        }
    }
    
}
