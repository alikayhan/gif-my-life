//
//  ForgotPasswordViewController.swift
//  Gif My Life
//
//  Created by Ali Kayhan on 02/08/2017.
//  Copyright © 2017 Ali Kayhan. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class ForgotPasswordViewController: PortraitUIViewController {
    
    // MARK: - Properties
    var promptLabel = UILabel()
    var emailTextField = UITextField()
    var resetPasswordButton = UIButton()
    var dismissButton = UIButton()
    var activityIndicator: NVActivityIndicatorView!
    
    // MARK: - Lifecycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: - Update View Constraints
    override func updateViewConstraints() {
        configureUI()
        super.updateViewConstraints()
    }
}

// MARK: - ForgotPasswordViewController: Configure UI

extension ForgotPasswordViewController {
    
    fileprivate func configureUI() {
        view.backgroundColor = UIConstants.Color.GMLLightPurple
        navigationItem.title = UIConstants.Title.ViewController.ForgotPassword
        
        // Initialize activity indicator
        activityIndicator = ActivityIndicator(on: view).indicator
        
        // Add tap gesture recognizer on view
        addGestureRecognizer(on: view)
        
        addTextFields()
        addButtons()
        addLabels()
    }
    
    fileprivate func addGestureRecognizer(on view: UIView) {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapRecognizer)
        view.isUserInteractionEnabled = true
    }
    
    @objc fileprivate func handleTap(_ sender: UITapGestureRecognizer) {
        resignIfFirstResponder(emailTextField)
    }
    
    fileprivate func addTextFields() {
        configure(emailTextField)
        
        view.addSubview(emailTextField)
        setConstraints(for: emailTextField)
    }
    
    fileprivate func configure(_ textField: UITextField) {
        textField.placeholder = UIConstants.Placeholder.SignInUp.EmailTextField
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        
        textField.textColor = UIConstants.Color.GMLPink
        textField.autocorrectionType = .no
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .white
        
        textField.layer.cornerRadius = UIConstants.Size.TextField.CornerRadius
        
        // Add padding for the text field
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        textField.attributedPlaceholder = textField.placeholder?.colored(with: UIConstants.Color.GMLLightPurple!)
        textField.tintColor = UIConstants.Color.GMLPurple
        textField.delegate = self
    }
    
    fileprivate func addButtons() {
        setUpButtons()
        
        view.addSubview(resetPasswordButton)
        view.addSubview(dismissButton)
        
        setConstraints(for: resetPasswordButton)
        setConstraints(for: dismissButton)
    }
    
    fileprivate func setUpButtons() {
        // Set up reset password button
        resetPasswordButton.backgroundColor = UIConstants.Color.GMLPurple
        resetPasswordButton.setTitle(UIConstants.Title.SignInUp.ResetPassword, for: .normal)
        resetPasswordButton.layer.cornerRadius = UIConstants.Size.Button.CornerRadius
        resetPasswordButton.translatesAutoresizingMaskIntoConstraints = false
        
        resetPasswordButton.addTarget(self, action: #selector(resetPassword), for: .touchUpInside)
        
        // Set up dismiss button
        dismissButton.setImage(UIImage(named: "Dismiss-2"), for: .normal)
        dismissButton.tintColor = .white
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        
        dismissButton.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
    }
    
    fileprivate func addLabels() {
        setUpLabels()
        view.addSubview(promptLabel)
        setConstraints(for: promptLabel)
    }
    
    fileprivate func setUpLabels() {
        promptLabel.text = UIConstants.Label.ForgotPassword.EnterEmail
        promptLabel.textAlignment = .center
        promptLabel.textColor = .white
        promptLabel.lineBreakMode = .byWordWrapping
        promptLabel.numberOfLines = 0
        promptLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    fileprivate func setConstraints(for subview: UIView) {
        let margins = view.layoutMarginsGuide
        
        switch subview {
        case promptLabel:
            subview.topAnchor.constraint(equalTo: margins.topAnchor, constant: 0.0).isActive = true
            subview.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            subview.heightAnchor.constraint(equalToConstant: 100.0).isActive = true
            subview.widthAnchor.constraint(equalToConstant: view.frame.width - 60.0).isActive = true
        case emailTextField:
            subview.topAnchor.constraint(equalTo: margins.topAnchor, constant: 80.0).isActive = true
            subview.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            subview.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
            subview.widthAnchor.constraint(equalToConstant: view.frame.width - 60.0).isActive = true
        case resetPasswordButton:
            subview.topAnchor.constraint(equalTo: margins.topAnchor, constant: 140.0).isActive = true
            subview.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            subview.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
            subview.widthAnchor.constraint(equalToConstant: view.frame.width - 60.0).isActive = true
        case dismissButton:
            subview.topAnchor.constraint(equalTo: margins.bottomAnchor, constant: -60.0).isActive = true
            subview.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            subview.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
            subview.widthAnchor.constraint(equalToConstant: 44.0).isActive = true
        default:
            break
        }
    }
    
    fileprivate func setUIEnabled(_ enabled: Bool) {
        DispatchQueue.main.async {
            self.emailTextField.isEnabled = enabled
            
            // Adjust reset password button alpha
            if enabled {
                self.activityIndicator.stopAnimating()
                self.resetPasswordButton.alpha = 1.0
            } else {
                self.activityIndicator.startAnimating()
                self.resetPasswordButton.alpha = 0.5
            }
        }
    }
}

// MARK: - ForgotPasswordViewController: Selectors

extension ForgotPasswordViewController {
    
    @objc fileprivate func resetPassword() {
        if emailTextField.text!.isEmpty {
            showAlert(with: UIConstants.Error.EmailEmpty)
        } else {
            setUIEnabled(false)
            FirebaseClient().shared.sendPasswordResetLink(to: emailTextField.text!, andHandleCompletionWith: { (error) in
                if let error = error {
                    self.setUIEnabled(true)
                    print(error)
                    self.showAlert(with: UIConstants.Error.ResetPasswordFailed)
                } else {
                    self.setUIEnabled(true)
                    self.showAlert(with: UIConstants.Confirmation.ResetPasswordLinkSent)
                }
            })
            
        }
        
    }
    
    @objc fileprivate func dismissViewController() {
        navigationController?.popViewController()
    }
}

// MARK: - ForgotPasswordViewController: UITextFieldDelegate

extension ForgotPasswordViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    fileprivate func resignIfFirstResponder(_ textField: UITextField) {
        if textField.isFirstResponder {
            textField.resignFirstResponder()
        }
    }
    
    func userDidTapView(_ sender: Any) {
        resignIfFirstResponder(emailTextField)
    }
}
