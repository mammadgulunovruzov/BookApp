//
//  ViewController.swift
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
        
        setupPasswordTogle()
        
        setupContinueButton()
    }


    @IBAction func continueTapped(_ sender: Any) {
        let username = usernameTextField.text ?? ""
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        
        //Validate email and password
        if !isValidEmail(email) {
            emailErrorLabel.isHidden = false
            emailErrorLabel.text = "Email is not valid"
        } else {
            emailErrorLabel.isHidden = true
        }
        
        if password.count < 6 || password.count > 25 {
            passwordErrorLabel.isHidden = false
            passwordErrorLabel.text = "Password must be between 6 and 25 characters"
        } else {
            passwordErrorLabel.isHidden = true
        }
        
        if emailErrorLabel.isHidden && passwordErrorLabel.isHidden {
            performSegue(withIdentifier: "toBookList", sender: username)
            
        }
        
    }
    
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }
    
    func setupPasswordTogle() {
        let eyeButton = UIButton(type: .custom)
        eyeButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        eyeButton.tintColor = .gray
        eyeButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        eyeButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        rightView.addSubview(eyeButton)
        passwordTextField.rightView = rightView
        passwordTextField.rightViewMode = .always
    }
    
    
    
    @objc func togglePasswordVisibility(_ sender: UIButton) {
        isPasswordVisible.toggle()
        passwordTextField.isSecureTextEntry = !isPasswordVisible
        sender.setImage(UIImage(systemName: isPasswordVisible ? "eye" : "eye.slash"), for: .normal)
        
    }
    
    
    func setupContinueButton() {
        continueButton.layer.cornerRadius = 20
        continueButton.layer.masksToBounds = true
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "toBookList",
               let bookListVC = segue.destination as? BookListViewController,
               let username = sender as? String {
                bookListVC.userName = username
            }
        }
    
    
}

