//
//  SignInUpViewController.swift
//  Gif My Life
//
//  Created by Ali Kayhan on 02/07/2017.
//  Copyright © 2017 Ali Kayhan. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class SignInUpViewController: PortraitUIViewController {
    
    // MARK: - Properties
    
    // This action tag is being used to decide if sign in or sign up
    // will be performed within this view controller
    var actionTag: String!
    
    var emailTextField = UITextField()
    var passwordTextField = UITextField()
    var usernameTextField = UITextField()
    
    var signInUpButton = UIButton()
    var forgotPasswordButton = UIButton()
    
    var activityIndicator: NVActivityIndicatorView!
    
    var keyboardIsOnScreen = false
    
    // MARK: - Initializers
    convenience init(for actionTag: String) {
        self.init()
        self.actionTag = actionTag
    }
    
    // MARK: - Lifecycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Update View Constraints
    override func updateViewConstraints() {
        configureUI()
        super.updateViewConstraints()
    }
}

// MARK: - SignInUpViewController: Configure UI

extension SignInUpViewController {
    
    fileprivate func configureUI() {
        view.backgroundColor = UIConstants.Color.GMLLightPurple
        navigationItem.title = actionTag
        
        // Initialize activity indicator
        activityIndicator = ActivityIndicator(on: view).indicator
        
        // Add tap gesture recognizer on view
        addGestureRecognizer(on: view)
        
        emailTextField.tag = 1
        passwordTextField.tag = 2
        usernameTextField.tag = 3
        
        addTextFields()
        addButtons()
    }
    
    fileprivate func setUIEnabled(_ enabled: Bool) {
        DispatchQueue.main.async {
            self.emailTextField.isEnabled = enabled
            self.passwordTextField.isEnabled = enabled
            self.signInUpButton.isEnabled = enabled
            
            // Adjust signInUp button alpha
            if enabled {
                self.activityIndicator.stopAnimating()
                self.signInUpButton.alpha = 1.0
            } else {
                self.activityIndicator.startAnimating()
                self.signInUpButton.alpha = 0.5
            }
        }
    }
    
    fileprivate func addGestureRecognizer(on view: UIView) {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapRecognizer)
        view.isUserInteractionEnabled = true
    }
    
    @objc fileprivate func handleTap(_ sender: UITapGestureRecognizer) {
        resignIfFirstResponder(emailTextField)
        resignIfFirstResponder(passwordTextField)
    }
    
    fileprivate func addTextFields() {
        configure(emailTextField)
        configure(passwordTextField)
        
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        
        setConstraints(for: emailTextField)
        setConstraints(for: passwordTextField)
        
        if actionTag == "Sign Up" {
            configure(usernameTextField)
            view.addSubview(usernameTextField)
            setConstraints(for: usernameTextField)
        }
    }
    
    fileprivate func configure(_ textField: UITextField) {
        switch textField.tag {
        case 1:
            textField.placeholder = UIConstants.Placeholder.SignInUp.EmailTextField
            textField.keyboardType = .emailAddress
            textField.autocapitalizationType = .none
        case 2:
            textField.placeholder = UIConstants.Placeholder.SignInUp.PasswordTextField
            textField.isSecureTextEntry = true
        case 3:
            textField.placeholder = UIConstants.Placeholder.SignInUp.UsernameTextField
            textField.autocapitalizationType = .none
        default:
            break
        }

        textField.textColor = UIConstants.Color.GMLPink
        textField.autocorrectionType = .no
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .white
        
        textField.layer.cornerRadius = UIConstants.Size.TextField.CornerRadius
        
        //Add padding for the text field
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        textField.attributedPlaceholder = textField.placeholder?.colored(with: UIConstants.Color.GMLLightPurple!)
        
        textField.tintColor = UIConstants.Color.GMLPurple
        textField.delegate = self
    }
    
    fileprivate func addButtons() {
        setUpButtons()
        
        view.addSubview(signInUpButton)
        view.addSubview(forgotPasswordButton)
        
        setConstraints(for: signInUpButton)
        setConstraints(for: forgotPasswordButton)
    }
    
    fileprivate func setUpButtons() {
        // Set up sign in/up button
        signInUpButton.backgroundColor = UIConstants.Color.GMLPurple
        signInUpButton.setTitle(actionTag, for: .normal)
        signInUpButton.layer.cornerRadius = UIConstants.Size.Button.CornerRadius
        signInUpButton.translatesAutoresizingMaskIntoConstraints = false
        
        if actionTag == "Sign Up" {
            signInUpButton.addTarget(self, action: #selector(signUp) , for: .touchUpInside)
        } else if actionTag == "Sign In" {
            signInUpButton.addTarget(self, action: #selector(signIn), for: .touchUpInside)
        }
        
        // Set up forgot password button
        forgotPasswordButton.setTitle(UIConstants.Title.SignInUp.ForgotPassword, for: .normal)
        forgotPasswordButton.titleLabel?.textColor = .white
        forgotPasswordButton.addTarget(self, action: #selector(presentForgotPasswordViewController), for: .touchUpInside)
        forgotPasswordButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    fileprivate func setConstraints(for subview: UIView) {
        let margins = view.layoutMarginsGuide
        
        switch subview {
        case emailTextField:
            subview.topAnchor.constraint(equalTo: margins.topAnchor, constant: 40.0).isActive = true
            subview.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            subview.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
            subview.widthAnchor.constraint(equalToConstant: view.frame.width - 60.0).isActive = true
        case passwordTextField:
            subview.topAnchor.constraint(equalTo: margins.topAnchor, constant: 100.0).isActive = true
            subview.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            subview.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
            subview.widthAnchor.constraint(equalToConstant: view.frame.width - 60.0).isActive = true
        case usernameTextField:
            subview.topAnchor.constraint(equalTo: margins.topAnchor, constant: 160.0).isActive = true
            subview.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            subview.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
            subview.widthAnchor.constraint(equalToConstant: view.frame.width - 60.0).isActive = true
        case signInUpButton:
            subview.topAnchor.constraint(equalTo: margins.bottomAnchor, constant: -120.0).isActive = true
            subview.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            subview.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
            subview.widthAnchor.constraint(equalToConstant: view.frame.width - 60.0).isActive = true
        case forgotPasswordButton:
            subview.topAnchor.constraint(equalTo: margins.bottomAnchor, constant: -60.0).isActive = true
            subview.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            subview.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
            subview.widthAnchor.constraint(equalToConstant: view.frame.width - 60.0).isActive = true
        default:
            break
        }
    }
}

// MARK: - SignInUpViewController: Selectors

extension SignInUpViewController {
    
    @objc fileprivate func presentForgotPasswordViewController() {
        let forgotPasswordViewController = ForgotPasswordViewController()
        navigationController?.pushViewController(forgotPasswordViewController, animated: true)
    }
    
    @objc fileprivate func signIn() {
        if emailTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            showAlert(with: UIConstants.Error.EmailPasswordEmpty)
        } else {
            setUIEnabled(false)
            
            FirebaseClient().shared.signIn(with: emailTextField.text!, and: passwordTextField.text!) { (user, error) in
                guard let user = user else {
                    self.showAlert(with: UIConstants.Error.SignInSignUpFailed)
                    self.setUIEnabled(true)
                    return
                }
                
                UserManager().shared.user = user
                UserManager().shared.obtainUserData()
                self.completeSignInSignUp()
            }
        }
    }
    
    @objc fileprivate func signUp() {
        if emailTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            showAlert(with: UIConstants.Error.EmailPasswordEmpty)
        } else if usernameTextField.text!.isEmpty || !((usernameTextField.text!.isAlphaNumeric) || (usernameTextField.text!.isNumeric) || (usernameTextField.text!.isAlphabetic)) {
            showAlert(with: UIConstants.Error.InvalidUsername)
        } else {
            setUIEnabled(false)
            
            FirebaseClient().shared.readData(at: "\(FirebaseClient.DatabaseKeys.Usernames)/\(self.usernameTextField.text!)") { (snapshot) in
                if snapshot.exists() {
                    self.showAlert(with: UIConstants.Error.UsernameAlreadyInUse)
                    self.setUIEnabled(true)
                } else {
                    FirebaseClient().shared.signUp(with: self.emailTextField.text!, and: self.passwordTextField.text!) { (user, error) in
                        guard let user = user else {
                            self.showAlert(with: UIConstants.Error.SignInSignUpFailed)
                            self.setUIEnabled(true)
                            return
                        }
                        UserManager().shared.user = user
                        UserManager().shared.username = self.usernameTextField.text!
                        UserManager().shared.obtainUserData()
                        self.completeSignInSignUp()
                    }
                }
            }
        }
    }
}

// MARK: - SignInUpViewController: Helper Functions

extension SignInUpViewController {

    fileprivate func completeSignInSignUp() {
        if UserManager().shared.user.email != nil {
            // dismiss(animated: true, completion: nil)
            navigationController?.dismiss(animated: true, completion: nil)
        } else {
            showAlert(with: UIConstants.Error.SignInSignUpFailed)
        }
        setUIEnabled(true)
    }
}

// MARK: - SignInUpViewController: UITextFieldDelegate

extension SignInUpViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if keyboardIsOnScreen == false {
            DispatchQueue.main.async {
                // TODO: - Move text fields up so that keyboard will not block the text fields
            }
        }
        
        // Reset password text field when editing begins
        if textField.tag == 2 {
            textField.text = ""
        }
        
        keyboardIsOnScreen = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if keyboardIsOnScreen == true {
            DispatchQueue.main.async {
                // TODO: - Move text fields down back to their original positions
            }
        }
        
        keyboardIsOnScreen = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    fileprivate func resignIfFirstResponder(_ textField: UITextField) {
        if textField.isFirstResponder {
            textField.resignFirstResponder()
        }
    }
    
    func userDidTapView( _ sender: Any) {
        resignIfFirstResponder(emailTextField)
        resignIfFirstResponder(passwordTextField)
        if actionTag == "Sign Up" {
            resignIfFirstResponder(usernameTextField)
        }
    }
}
