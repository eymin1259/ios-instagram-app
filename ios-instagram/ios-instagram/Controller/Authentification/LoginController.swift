import UIKit

class LoginController: UIViewController{
    
    // MARK: properties
    
    private let indicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView()
        ai.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        ai.color = .white
        ai.startAnimating()
        ai.isHidden = true
        return ai
    }()
    
    private var loginViewModel = LoginViewModel()
    
    private let iconImage: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "Instagram_logo_white"))
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private let emailTextField: UITextField = {
        let tf = CustomTextField(placeholder: "Email") // custom subclass
        tf.keyboardType = .emailAddress
        return tf
    }()
    
    private let passwordTextField: UITextField = {
        let tf = CustomTextField(placeholder: "Password") // custom subclass
        tf.isSecureTextEntry = true
        return tf
    }()
    
    private let loginBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Log in", for: .normal)
        btn.setTitleColor(UIColor(white: 1, alpha: 0.2), for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        btn.backgroundColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1).withAlphaComponent(0.1)
        btn.isEnabled = false
        btn.layer.cornerRadius = 5
        btn.setHeight(50)
        btn.addTarget(self, action: #selector(handlLogin), for: .touchUpInside)
        return btn
    }()
    
    private let dontHaveAccountBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.attributedTitle(firstPart: "Don't have an account?", secondPart: "Sign Up") // extending
        btn.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        return btn
    }()
    
    private let forgotPasswordBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.attributedTitle(firstPart: "Forgot your password?", secondPart: "Get help signing in") // extending
        return btn
    }()
    
    // MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
            
        configureUI()
        setupGesture()
        configureNotificationObserver()
    }
    
    // MARK: helpers
    func configureUI() {
        configureGradientLayer() // extension
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
        
        view.addSubview(iconImage)
        iconImage.centerX(inView: view)
        iconImage.setDimensions(height: 80, width: 120)
        iconImage.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 30)
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginBtn, forgotPasswordBtn, indicator])
        stackView.axis = .vertical
        stackView.spacing = 15
        
        view.addSubview(stackView)
        stackView.anchor(top: iconImage.bottomAnchor,left: view.leftAnchor, right: view.rightAnchor, paddingTop: 30, paddingLeft: 30, paddingRight: 30)
        
        view.addSubview(dontHaveAccountBtn)
        dontHaveAccountBtn.centerX(inView: view)
        dontHaveAccountBtn.anchor(bottom:view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 20)
        
    }
    
    
    func configureNotificationObserver(){
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        // extension AddCityViewController: UIGestureRecognizerDelegate
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
    }
    
    
    // MARK: actions
    @objc func handleShowSignUp() {
        let controller = RegisterController()
        navigationController?.pushViewController(controller, animated: true)
        // window?.rootViewController = UINavigationController(rootViewController: LoginController())
    }

    @objc func textDidChange(sender: UITextView) {
        if sender == emailTextField {
            loginViewModel.email = sender.text
        }
        else if sender == passwordTextField {
            loginViewModel.password = sender.text
        }
        
        // mvvm : view업데이트 로직을 vm이 담당
        loginBtn.backgroundColor = loginViewModel.btnBackground
        loginBtn.isEnabled = loginViewModel.formValid
        loginBtn.setTitleColor(loginViewModel.btnTitleColor, for: .normal)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func handlLogin() {
        indicator.isHidden = false
        
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        AuthService.logUserIn(email: email, password: password) { (result, error) in
            if let error = error {
                print("debug : failed to login -> \(error.localizedDescription)")
                self.indicator.isHidden = true
            }
            
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension LoginController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        return touch.view == self.view
    }
}
