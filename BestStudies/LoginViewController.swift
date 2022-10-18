// Project: LoginViewController.swift
// EID: Jac23662
// Course: CS371L


import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var userField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordField.isSecureTextEntry = true
        // Do any additional setup after loading the view.
        Auth.auth().addStateDidChangeListener() {
            auth, user in
            if user != nil {
                self.performSegue(withIdentifier: "homeSegue", sender: nil)
                self.userField.text = nil
                self.passwordField.text = nil
            }
        }
    }
    
    @IBAction func signinButton(_ sender: Any) {
        Auth.auth().signIn(withEmail: userField.text!, password: passwordField.text!) {
            authResult, error in
            if let error = error as NSError? {
                self.errorLabel.text = "\(error.localizedDescription)"
            } else {
                self.errorLabel.text = ""
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
     @IBAction func signinButton(_ sender: Any) {
     }
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
     }
    */

}
