// Project: LoginViewController.swift
// EID: Jac23662
// Course: CS371L


import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                // Do any additional setup after loading the view.
        Auth.auth().addStateDidChangeListener() {
            auth, user in
            if user != nil {
                self.performSegue(withIdentifier: "homeSegue", sender: nil)
                self.emailField.text = nil
                self.passwordField.text = nil
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //passwordField.isSecureTextEntry = true
    }
    
    @IBAction func signinButton(_ sender: Any) {
//        Auth.auth().signIn(withEmail: userField.text!, password: passwordField.text!) {
//            authResult, error in
//            if let error = error as NSError? {
//                self.errorLabel.text = "\(error.localizedDescription)"
//            } else {
//                self.errorLabel.text = ""
//            }
//        }
        AuthManager.shared.signIn(email: emailField.text ?? "", password: passwordField.text ?? "", errorLabel: errorLabel) {
            [weak self] success in
            guard success else {
                return
            }
        }
    }

}
