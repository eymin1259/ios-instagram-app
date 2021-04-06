import UIKit

class RegisterController: UIViewController{
    
    // MARK: properties
    
    private var registerViewModel = RegisterationViewModel()
    private var profileImage: UIImage?
    
    private let plusPhotoBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "plus_photo"), for: .normal)
        btn.tintColor = .white
        btn.addTarget(self, action: #selector(handlePlusPhotoBtn), for: .touchUpInside)
        return btn
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
    
    private let fullnameTextField = CustomTextField(placeholder: "Fullname")
    private let usernameTextField = CustomTextField(placeholder: "Username")
    
    private let signupBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Sign up", for: .normal)
        btn.setTitleColor(UIColor(white: 1, alpha: 0.2), for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        btn.backgroundColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1).withAlphaComponent(0.1)
        btn.isEnabled = false
        btn.layer.cornerRadius = 5
        btn.setHeight(50)
        btn.addTarget(self, action: #selector(handleSingup), for: .touchUpInside)
        return btn
    }()
    
    private let alredyHaveAccountBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.attributedTitle(firstPart: "Already have an account?", secondPart: "Log in") // extending
        btn.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
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
        
        view.addSubview(plusPhotoBtn)
        plusPhotoBtn.centerX(inView: view)
        plusPhotoBtn.setDimensions(height: 140, width: 140)
        plusPhotoBtn.anchor(top:view.safeAreaLayoutGuide.topAnchor, paddingTop: 35)
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, fullnameTextField, usernameTextField, signupBtn])
        stackView.axis = .vertical
        stackView.spacing = 15
        
        view.addSubview(stackView)
        stackView.anchor(top: plusPhotoBtn.bottomAnchor,left: view.leftAnchor, right: view.rightAnchor, paddingTop: 30, paddingLeft: 30, paddingRight: 30)
        
        view.addSubview(alredyHaveAccountBtn)
        alredyHaveAccountBtn.centerX(inView: view)
        alredyHaveAccountBtn.anchor(bottom:view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 20)

    }
    
    func configureNotificationObserver(){
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        fullnameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        usernameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    
    func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        // extension AddCityViewController: UIGestureRecognizerDelegate
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: actions
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func handleShowLogin() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func textDidChange(sender: UITextView) {
        if sender == emailTextField {
            registerViewModel.email = sender.text
        }
        else if sender == passwordTextField {
            registerViewModel.password = sender.text
        }
        else if sender == fullnameTextField {
            registerViewModel.fullname = sender.text
        }
        else if sender == usernameTextField {
            registerViewModel.username = sender.text
        }

        // mvvm : view업데이트 로직을 vm이 담당
        signupBtn.backgroundColor = registerViewModel.btnBackground
        signupBtn.isEnabled = registerViewModel.formValid
        signupBtn.setTitleColor(registerViewModel.btnTitleColor, for: .normal)
    }
    
    
    @objc func handlePlusPhotoBtn() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
        
    }
    
    @objc func handleSingup(){
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let fullname = fullnameTextField.text else { return }
        guard let username = usernameTextField.text else { return }
        guard let profileImage = self.profileImage else {return }
        
        let credentials = AuthCredentials(email: email, password: password, fullname: fullname, username: username, profileImage: profileImage)
        
        //API
        AuthService.registerUser(withCredentials: credentials) { (error) in
            if let error = error {
                print("debug: failed to register user -> \(error.localizedDescription)")
                return
            }
            print("debug : success to register user with firebase")
        }
    }
    
}

extension RegisterController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        return touch.view == self.view
    }
}


// UIImagePickerControllerDelegate
extension RegisterController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selectedImage = info[.editedImage] as? UIImage else {return}
        
        profileImage = selectedImage
        
        plusPhotoBtn.layer.cornerRadius = plusPhotoBtn.frame.width/2
        plusPhotoBtn.layer.masksToBounds = true
        plusPhotoBtn.layer.borderColor = UIColor.white.cgColor
        plusPhotoBtn.layer.borderWidth = 2
        plusPhotoBtn.setImage(selectedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        
        // dismiss picker
        dismiss(animated: true, completion: nil)
    }
}
