//
//  AccountSettingsViewController.swift
//  BestStudies
//
//  Created by Jack Si on 10/17/22.
//

import UIKit
import FirebaseAuth

class AccountSettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let accountSettings = ["Change Email", "Change Username", "Change Password", "Log Out", "Delete Account"]
    
    let cellIdentifier = "AccountCellIdentifier"
    
    private var user: UserProfile?
    private var email = UserDefaults.standard.string(forKey: "email")
    private var userName = UserDefaults.standard.string(forKey: "userName")
    private var password = UserDefaults.standard.string(forKey: "password")
    
    @IBOutlet weak var accountTable: UITableView!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setup Table view
        accountTable.delegate = self
        accountTable.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accountSettings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath as IndexPath)
        let row = indexPath.row
        cell.textLabel?.text = accountSettings[row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
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
        let changeEmailSheet = UIAlertController(title: "Change Email", message: "Current Email: \(String(describing: email))", preferredStyle: .alert)
        changeEmailSheet.addTextField()
        changeEmailSheet.textFields![0].placeholder = "Enter New Email"
        changeEmailSheet.addTextField()
        changeEmailSheet.textFields![1].placeholder = "Enter Current Password"

        let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned changeEmailSheet] _ in
            let newEmail = changeEmailSheet.textFields![0].text
            let password = changeEmailSheet.textFields![1].text
            if(password == self.password) {
                if(newEmail == "") {
                    self.errorLabel.text = "Please Input New Email"
                }
                else {
                    self.email = newEmail!
                    UserDefaults.standard.set(newEmail!, forKey: "email")
                    self.errorLabel.text = ""
                    AuthManager.shared.changeEmail(email: newEmail!)
                }
            }
            else {
                self.errorLabel.text = "Incorrect Password"
            }
        }
        changeEmailSheet.addAction(submitAction)

        present(changeEmailSheet, animated: true)
    }
    
    func changeUsernameSelected() {
        let changeUnameSheet = UIAlertController(title: "Change Username", message: "Current Username: \(String(describing: userName))", preferredStyle: .alert)
        changeUnameSheet.addTextField()
        changeUnameSheet.textFields![0].placeholder = "Enter New Username"

        let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned changeUnameSheet] _ in
            let newUserName = changeUnameSheet.textFields![0].text
            if(newUserName == "") {
                self.errorLabel.text = "Please Input New Username"
            }
            else {
                // TODO Add Logic for database profile changing
                self.userName = newUserName!
                UserDefaults.standard.set(newUserName!, forKey: "userName")
                self.errorLabel.text = ""
            }
            
        }
        changeUnameSheet.addAction(submitAction)

        present(changeUnameSheet, animated: true)
    }
    
    
    func changePasswordSelected() {
        let changePasswordSheet = UIAlertController(title: "Change Password", message: "Please verify password", preferredStyle: .alert)
        changePasswordSheet.addTextField()
        changePasswordSheet.textFields![0].placeholder = "Enter Current Password"
        changePasswordSheet.addTextField()
        changePasswordSheet.textFields![1].placeholder = "Enter New Password"
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned changePasswordSheet] _ in
            let currentPassword = changePasswordSheet.textFields![0].text
            let newPassword = changePasswordSheet.textFields![1].text
            if(currentPassword == self.password) {
                if(newPassword == "") {
                    self.errorLabel.text = "Please Input New Password"
                }
                else {
                    self.password = newPassword!
                    self.errorLabel.text = ""
                    UserDefaults.standard.set(newPassword!, forKey: "password")
                    AuthManager.shared.changePassword(password: newPassword!)
                }
            }
            else {
                self.errorLabel.text = "Incorrect Password"
            }
        }
        
        changePasswordSheet.addAction(submitAction)

        present(changePasswordSheet, animated: true)
    }
    
    func logoutSelected() {
        let signOutSheet = UIAlertController(title: "Sign Out", message: "Are you sure?", preferredStyle: .actionSheet)
        signOutSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        signOutSheet.addAction(UIAlertAction(title:"Sign Out", style: .destructive, handler: { sender in
            AuthManager.shared.signOut()
            self.performSegue(withIdentifier: "SignOutSegue", sender: self)
        }))
        present(signOutSheet, animated: true)
    }
    
    func deactivateSelected() {
        let signOutSheet = UIAlertController(title: "Delete Account", message: "Are you sure you want to delete your account?", preferredStyle: .actionSheet)
        signOutSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        signOutSheet.addAction(UIAlertAction(title:"Delete", style: .destructive, handler: { sender in
            AuthManager.shared.deleteAccount()
            self.performSegue(withIdentifier: "SignOutSegue", sender: self)
        }))
        present(signOutSheet, animated: true)
    }
}
func promptForAnswer() {
    
}
