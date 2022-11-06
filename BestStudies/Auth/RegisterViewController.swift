// Project: RegisterViewController.swift
// EID: Jac23662
// Course: CS371L


import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var userField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var repeatField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordField.isSecureTextEntry = true
        repeatField.isSecureTextEntry = true
        // Do any additional setup after loading the view.

    }
    
    override func viewWillAppear(_ animated: Bool) {
        Auth.auth().addStateDidChangeListener() {
            auth, user in
            if user != nil {
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
                self.userField.text = nil
                self.passwordField.text = nil
            }
        }
    }
    
    @IBAction func signupButtonPressed(_ sender: Any) {

        if(passwordField.text != repeatField.text) {
            errorLabel.text = "Passwords did not match!"
            return
        }
        else {
            AuthManager.shared.signUp(email: emailField.text!, userName: userField.text!, password: passwordField.text!, errorLabel: errorLabel) {
                [weak self] success in
                guard success else {
                    UserDefaults.standard.set(true, forKey: "soundOn")
                    UserDefaults.standard.set(0.5, forKey: "soundVolume")
                    SoundManager.shared.playButtonSound(sound: .buttonNoise)
                    return
                }
            }
        }
    }
    
    @IBAction func signInButton(_ sender: Any) {
        SoundManager.shared.playButtonSound(sound: .chillButton)
    }
    

}
