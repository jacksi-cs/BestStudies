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
        passwordField.isSecureTextEntry = true
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
        AuthManager.shared.signIn(email: emailField.text ?? "", password: passwordField.text ?? "", errorLabel: errorLabel) {
            [weak self] success in
            guard success else {
                return
            }
            SoundManager.shared.playButtonSound(sound: .buttonNoise)
        }
    }
    
    @IBAction func signUpButton(_ sender: Any) {
        SoundManager.shared.playButtonSound(sound: .chillButton)
    }
    
}
