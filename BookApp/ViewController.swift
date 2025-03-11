//
//  RegisterViewController.swift
//  BookApp
//
//  Created by Mammadgulu Novruzov on 04.03.25.
//

import UIKit

class RegisterViewController: UIViewController {
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var continueButton: UIButton!
    
    @IBOutlet var emailErrorLabel: UILabel!
    @IBOutlet var passwordErrorLabel: UILabel!
    
    var isPasswordVisible = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailErrorLabel.isHidden = true
        passwordErrorLabel.isHidden = true
        
        // Style the text fields
        styleTextField(usernameTextField)
        styleTextField(emailTextField)
        styleTextField(passwordTextField)
        
        setupPasswordToggle()
        setupUI()
    }
    
    @IBAction func continueTapped(_ sender: Any) {
        let username = usernameTextField.text ?? ""
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        var isValid = true
        
        // Validate Email
        if !isValidEmail(email) {
            emailErrorLabel.isHidden = false
            emailErrorLabel.text = "Invalid email format"
            emailTextField.layer.borderColor = UIColor.red.cgColor
            isValid = false
        } else {
            emailErrorLabel.isHidden = true
            emailTextField.layer.borderColor = UIColor.darkGray.cgColor
        }
        
        // Validate Password
        if password.count < 6 || password.count > 25 {
            passwordErrorLabel.isHidden = false
            passwordErrorLabel.text = "Password must be 6-25 characters"
            passwordTextField.layer.borderColor = UIColor.red.cgColor
            isValid = false
        } else {
            passwordErrorLabel.isHidden = true
            passwordTextField.layer.borderColor = UIColor.darkGray.cgColor
        }
        
        // Proceed if valid
        if isValid {
            performSegue(withIdentifier: "toBookList", sender: username)
        }
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    
    func setupPasswordToggle() {
        let eyeButton = UIButton(type: .custom)
        eyeButton.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        eyeButton.tintColor = .gray
        eyeButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        eyeButton.contentMode = .scaleAspectFit
        eyeButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        eyeButton.center = rightView.center
        rightView.addSubview(eyeButton)
        
        passwordTextField.rightView = rightView
        passwordTextField.rightViewMode = .always
    }

    
    @objc func togglePasswordVisibility(_ sender: UIButton) {
        isPasswordVisible.toggle()
        passwordTextField.isSecureTextEntry = !isPasswordVisible
        sender.setImage(UIImage(systemName: isPasswordVisible ? "eye" : "eye.fill"), for: .normal)
    }
    
    func setupUI() {
        // Round corners for button
        continueButton.layer.cornerRadius = 20
        continueButton.layer.masksToBounds = true
        
        // Create a stack view *without* the continueButton
        let stackView = UIStackView(arrangedSubviews: [
            usernameTextField,
            emailTextField,
            emailErrorLabel,
            passwordTextField,
            passwordErrorLabel
        ])
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Add the stackView to the view
        view.addSubview(stackView)
        
        // Pin the stackView to the top (using safeAreaLayoutGuide)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
        
        // Add the continueButton separately and pin it to the bottom
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(continueButton)
        
        NSLayoutConstraint.activate([
            continueButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            continueButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            continueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            continueButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func styleTextField(_ textField: UITextField) {
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor.darkGray.cgColor  // Default border color
        textField.layer.cornerRadius = 8
        textField.layer.masksToBounds = true
        textField.setLeftPadding(12) // Helper function for padding
        textField.heightAnchor.constraint(equalToConstant: 45).isActive = true // Increase height
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toBookList",
           let bookListVC = segue.destination as? BookListViewController,
           let username = sender as? String {
            bookListVC.userName = username
        }
    }
}

extension UITextField {
    func setLeftPadding(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}
