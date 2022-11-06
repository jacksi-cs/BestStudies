//
//  AccountSettingsViewController.swift
//  BestStudies
//
//  Created by Jack Si on 10/17/22.
//

import UIKit
import FirebaseAuth

class AccountSettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let cellIdentifier = "AccountCellIdentifier"
    
    private var user: UserProfile?
    private var email = AuthManager.shared.getCurrentEmail()
    @IBOutlet weak var emailField: UILabel!
    @IBOutlet weak var userNameField: UILabel!
    
    let accountSettings = ["Change Email", "Change Username", "Change Password", "Log Out", "Delete Account"]
    
    @IBOutlet weak var accountTable: UITableView!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup Table view
        accountTable.delegate = self
        accountTable.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        userNameField.text = AuthManager.shared.getCurrentUser()
        emailField.text = AuthManager.shared.getCurrentEmail()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accountSettings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath as IndexPath)
        let row = indexPath.row
        cell.textLabel?.text = accountSettings[row]
        if(row == 4) {
            cell.textLabel?.textColor = .systemRed
            cell.textLabel?.font  = UIFont.boldSystemFont(ofSize: 14.0)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        SoundManager.shared.playButtonSound(sound: .chillButton)
        switch indexPath.row {
        case 0:
            changeEmailSelected()
        case 1:
            changeUsernameSelected()
        case 2:
            changePasswordSelected()
        case 3:
            logoutSelected()
        case 4:
            deactivateSelected()
        default:
            print("Hit default case in settings switch");
        }
    }
    
    func changeEmailSelected() {
        let changeEmailSheet = UIAlertController(title: "Change Email", message: "Current Email: \(email)", preferredStyle: .alert)
        // TextField for email
        changeEmailSheet.addTextField()
        changeEmailSheet.textFields![0].placeholder = "Enter New Email"
        
        // TextField for password
        changeEmailSheet.addTextField()
        changeEmailSheet.textFields![1].placeholder = "Enter Current Password"
        changeEmailSheet.textFields![1].isSecureTextEntry = true

        let submitAction = UIAlertAction(title: "Submit", style: .default) { [self, unowned changeEmailSheet] _ in
            let newEmail = changeEmailSheet.textFields![0].text
            let password = changeEmailSheet.textFields![1].text
            if(password == password) {
                if(newEmail == "") {
                    self.errorLabel.text = "Please Input New Email"
                }
                else {
                    self.email = newEmail!
                    self.errorLabel.text = ""
                    AuthManager.shared.changeEmail(email: newEmail!, errorLabel: errorLabel, emailLabel: emailField)
                    
                }
            }
            else {
                self.errorLabel.text = "Incorrect Password"
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        changeEmailSheet.addAction(submitAction)
        changeEmailSheet.addAction(cancelAction)
        present(changeEmailSheet, animated: true)
    }
    
    func changeUsernameSelected() {
        let changeUnameSheet = UIAlertController(title: "Change Username", message: "Current Username: \(userNameField.text!)", preferredStyle: .alert)
        changeUnameSheet.addTextField()
        changeUnameSheet.textFields![0].placeholder = "Enter New Username"

        let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned changeUnameSheet] _ in
            let newUserName = changeUnameSheet.textFields![0].text
            SoundManager.shared.playButtonSound(sound: .buttonNoise)
            if(newUserName == "") {
                self.errorLabel.text = "Please Input New Username"
            }
            else {
                self.userNameField.text = newUserName
                AuthManager.shared.changeUsername(userName: newUserName!)
                self.errorLabel.text = ""
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        changeUnameSheet.addAction(submitAction)
        changeUnameSheet.addAction(cancelAction)

        present(changeUnameSheet, animated: true)
    }
    
    
    func changePasswordSelected() {
        let changePasswordSheet = UIAlertController(title: "Change Password", message: "Please verify password", preferredStyle: .alert)
        // Current Password field
        changePasswordSheet.addTextField()
        changePasswordSheet.textFields![0].placeholder = "Enter Current Password"
        changePasswordSheet.textFields![0].isSecureTextEntry = true
        
        // New Password Field
        changePasswordSheet.addTextField()
        changePasswordSheet.textFields![1].placeholder = "Enter New Password"
        changePasswordSheet.textFields![1].isSecureTextEntry = true
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned changePasswordSheet] _ in
            let currentPassword = changePasswordSheet.textFields![0].text
            let newPassword = changePasswordSheet.textFields![1].text
            //To-do get better check
            if(currentPassword == currentPassword) {
                if(newPassword == "") {
                    self.errorLabel.text = "Please Input New Password"
                }
                else {
                    self.errorLabel.text = ""
                    AuthManager.shared.changePassword(password: newPassword!)
                    SoundManager.shared.playButtonSound(sound: .buttonNoise)
                }
            }
            else {
                self.errorLabel.text = "Incorrect Password"
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        changePasswordSheet.addAction(submitAction)
        changePasswordSheet.addAction(cancelAction)

        present(changePasswordSheet, animated: true)
    }
    
    func logoutSelected() {
        let signOutSheet = UIAlertController(title: "Sign Out", message: "Are you sure?", preferredStyle: .actionSheet)
        signOutSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        signOutSheet.addAction(UIAlertAction(title:"Sign Out", style: .destructive, handler: { sender in
            SoundManager.shared.playButtonSound(sound: .chillButton)
            AuthManager.shared.signOut()
            self.performSegue(withIdentifier: "SignOutSegue", sender: self)
        }))
        present(signOutSheet, animated: true)
    }
    
    func deactivateSelected() {
        let signOutSheet = UIAlertController(title: "Delete Account", message: "Are you sure you want to delete your account?", preferredStyle: .actionSheet)
        signOutSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        signOutSheet.addAction(UIAlertAction(title:"Delete", style: .destructive, handler: { sender in
            SoundManager.shared.playButtonSound(sound: .chillButton)
            AuthManager.shared.deleteAccount()
            self.performSegue(withIdentifier: "SignOutSegue", sender: self)
        }))
        present(signOutSheet, animated: true)
    }
}
func promptForAnswer() {
    
}
