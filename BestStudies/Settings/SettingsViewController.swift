//
//  SettingsViewController.swift
//  BestStudies
//
//  Created by Jack Si on 10/17/22.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let settings = ["Change Email", "Change Username", "Change Password", "Sound On/Off", "App Volume", "Notifications On/Off", "Logout", "Delete Account"]
    
    let cellIdentifier = "SettingCellIdentifier"

    private var currentEmail = AuthManager.shared.getCurrentEmail()
    private var currentUserName = AuthManager.shared.getCurrentUser()
    
    // Cell 1 object(s)
    var changeEmailButton: UIButton?
    var emailLabel: UILabel?
    
    // Cell 2 Object(s)
    var changeUserNameButton: UIButton?
    var userNameLabel: UILabel?
    
    // Cell 3 Object
    var changePasswordButton: UIButton?
    
    // Cell 4 Object(s)
    var soundOnSwitch: UISwitch?
    
    // Cell 5 Object(s)
    var soundSlider: UISlider?
    
    // Cell 6 Object(s)
    var notificationOnSwitch: UISwitch?
    
    //Cell 7 Object(s)
    var logoutButton: UIButton?
    
    //Cell 8 Object(s)
    var deleteAccountButton: UIButton?
    
    @IBOutlet weak var settingsTable: UITableView!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingsTable.delegate = self
        settingsTable.dataSource = self
        
        emailLabel = UILabel(frame: CGRectMake(140.0, 0.0, 240.0, 42.8))
        changeEmailButton = UIButton(frame: CGRectMake(0, 0, 393.0, 42.8))
        
        userNameLabel = UILabel(frame: CGRectMake(140.0, 0.0, 240.0, 42.8))
        changeUserNameButton = UIButton(frame: CGRectMake(0, 0, 393.0, 42.8))
        
        changePasswordButton = UIButton(frame: CGRectMake(0, 0, 393.0, 43.2))
        
        soundOnSwitch = UISwitch(frame: CGRectMake(330, 7.0, 240.0, 42.8))
        
        soundSlider = UISlider(frame: CGRectMake(170.0, 1.0, 210.0, 42.8))
        
        notificationOnSwitch = UISwitch(frame: CGRectMake(330, 7.0, 240.0, 42.8))
        
        logoutButton = UIButton(frame: CGRectMake(0, 0, 393.0, 42.8))
        
        deleteAccountButton = UIButton(frame: CGRectMake(0, 0, 393.0, 42.8))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        self.settingsTable.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        userNameLabel!.text = AuthManager.shared.getCurrentUser()
        emailLabel!.text = AuthManager.shared.getCurrentEmail()
        soundOnSwitch!.isOn = UserDefaults.standard.bool(forKey: "soundOn")
        soundSlider!.value = UserDefaults.standard.float(forKey: "soundVolume")
        notificationOnSwitch!.isOn = UserDefaults.standard.bool(forKey: "notificationsOn")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath as IndexPath)
        let row = indexPath.row
        cell.textLabel?.text = settings[row]
        cell.backgroundColor = .white
        switch indexPath.row {
        case 0:
            
            // Set Email Label that shows current email
            emailLabel!.textAlignment = NSTextAlignment.left
            emailLabel!.text = currentEmail
            emailLabel!.textAlignment = NSTextAlignment.right
            emailLabel!.textColor = .systemGray
            emailLabel!.tag = indexPath.row
            
            // Set up a button since didSelectRowAt will not work for varried cell types
            changeEmailButton!.addTarget(self, action: #selector(changeEmailButtonPressed), for: .touchUpInside)
            changeEmailButton!.tag = indexPath.row
            
            cell.contentView.addSubview(changeEmailButton!)
            cell.contentView.addSubview(emailLabel!)
        case 1:
            userNameLabel!.textAlignment = NSTextAlignment.left
            userNameLabel!.text = currentUserName
            userNameLabel!.textAlignment = NSTextAlignment.right
            userNameLabel!.textColor = .systemGray
            userNameLabel!.tag = indexPath.row
            
            changeUserNameButton!.addTarget(self, action: #selector(changeUserNameButtonPressed), for: .touchUpInside)
            changeUserNameButton!.tag = indexPath.row
            
            cell.contentView.addSubview(userNameLabel!)
            cell.contentView.addSubview(changeUserNameButton!)
        case 2:
            changePasswordButton!.addTarget(self, action: #selector(changePasswordButtonPressed), for: .touchUpInside)
            
            cell.contentView.addSubview(changePasswordButton!)
        case 3:
            soundOnSwitch!.tag = indexPath.row
            soundOnSwitch!.addTarget(self, action: #selector(soundOnSwitchPressed), for: .valueChanged)
            cell.contentView.addSubview(soundOnSwitch!)
        case 4:
            soundSlider!.maximumTrackTintColor = .systemGray6
            soundSlider!.minimumTrackTintColor = .systemGreen
            soundSlider!.addTarget(self, action: #selector(soundVolumeChanged), for: .valueChanged)
            cell.contentView.addSubview(soundSlider!)
        case 5:
            notificationOnSwitch!.addTarget(self, action: #selector(notificationOnSwitchPressed), for: .valueChanged)
            cell.contentView.addSubview(notificationOnSwitch!)
        case 6:
            logoutButton!.addTarget(self, action: #selector(logoutButtonPressed), for: .touchUpInside)
            
            cell.contentView.addSubview(logoutButton!)
        case 7:
            deleteAccountButton!.addTarget(self, action: #selector(deleteAccountButtonPressed), for: .touchUpInside)
            
            cell.textLabel?.textColor = .systemRed
            cell.textLabel?.font  = UIFont.boldSystemFont(ofSize: 14.0)
            
            cell.contentView.addSubview(deleteAccountButton!)
        default:
            break
        }
        return cell
    }
    
    @objc func changeEmailButtonPressed(sender: UIButton!) {
        animateButtonPress(buttonToAnimate: changeEmailButton!)
        SoundManager.shared.playButtonSound(sound: .chillButton)
        
        let changeEmailSheet = UIAlertController(title: "Change Email", message: "Current Email: \(currentEmail)", preferredStyle: .alert)
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
                    self.errorLabel.text = ""
                    AuthManager.shared.changeEmail(email: newEmail!, errorLabel: errorLabel) {
                        [weak self] success in
                        guard success else {
                            return
                        }
                        self!.currentEmail = newEmail!
                        self!.emailLabel!.text = newEmail!
                    }
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
    
    @objc func changeUserNameButtonPressed(sender: UIButton!) {
        animateButtonPress(buttonToAnimate: changeUserNameButton!)
        SoundManager.shared.playButtonSound(sound: .chillButton)
        
        let changeUnameSheet = UIAlertController(title: "Change Username", message: "Current Username: \(currentUserName)", preferredStyle: .alert)
        changeUnameSheet.addTextField()
        changeUnameSheet.textFields![0].placeholder = "Enter New Username"

        let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned changeUnameSheet] _ in
            let newUserName = changeUnameSheet.textFields![0].text
            SoundManager.shared.playButtonSound(sound: .buttonNoise)
            if(newUserName == "") {
                self.errorLabel.text = "Please Input New Username"
            }
            else {
                self.currentUserName = newUserName!
                self.userNameLabel!.text = newUserName
                AuthManager.shared.changeUsername(userName: newUserName!)
                self.errorLabel.text = ""
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        changeUnameSheet.addAction(submitAction)
        changeUnameSheet.addAction(cancelAction)

        present(changeUnameSheet, animated: true)
    }
    
    @objc func changePasswordButtonPressed(sender: UIButton!) {
        animateButtonPress(buttonToAnimate: changePasswordButton!)
        SoundManager.shared.playButtonSound(sound: .chillButton)
        
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
    
    @objc func soundOnSwitchPressed(sender: UISwitch!) {
        SoundManager.shared.playButtonSound(sound: .chillButton)
        UserDefaults.standard.set(soundOnSwitch!.isOn, forKey: "soundOn")
    }
    
    @objc func soundVolumeChanged(_ sender: Any) {
        SoundManager.shared.playButtonSound(sound: .chillButton)
        UserDefaults.standard.set(soundSlider!.value, forKey: "soundVolume")
    }
    
    @objc func notificationOnSwitchPressed(sender: UISwitch!) {
        SoundManager.shared.playButtonSound(sound: .chillButton)
        UserDefaults.standard.set(notificationOnSwitch!.isOn, forKey: "notificationsOn")
        let current = UNUserNotificationCenter.current()
        let notificationsOn = self.notificationOnSwitch!.isOn
        current.getNotificationSettings { settings in
            if(settings.authorizationStatus == .denied && notificationsOn) {
                DispatchQueue.main.async {
                    self.presentMessage()
                }
            }
        }
    }
    
    @objc func logoutButtonPressed(sender: UIButton!) {
        SoundManager.shared.playButtonSound(sound: .chillButton)
        animateButtonPress(buttonToAnimate: logoutButton!)
        
        let signOutSheet = UIAlertController(title: "Sign Out", message: "Are you sure?", preferredStyle: .actionSheet)
        signOutSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        signOutSheet.addAction(UIAlertAction(title:"Sign Out", style: .destructive, handler: { sender in
            SoundManager.shared.playButtonSound(sound: .chillButton)
            AuthManager.shared.signOut() {
                [weak self] success in
                guard success else {
                    return
                }
                self!.performSegue(withIdentifier: "SignOutSegue", sender: self)
            }
        }))
        present(signOutSheet, animated: true)
    }
    
    @objc func deleteAccountButtonPressed(sender: UIButton!) {
        animateButtonPress(buttonToAnimate: deleteAccountButton!)
        SoundManager.shared.playButtonSound(sound: .chillButton)
        
        let signOutSheet = UIAlertController(title: "Delete Account", message: "Are you sure you want to delete your account?", preferredStyle: .actionSheet)
        signOutSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        signOutSheet.addAction(UIAlertAction(title:"Delete", style: .destructive, handler: { sender in
            SoundManager.shared.playButtonSound(sound: .chillButton)
            AuthManager.shared.deleteAccount(errorLabel: self.errorLabel) {
                [weak self] success in
                guard success else {
                    return
                }
                AuthManager.shared.signOut() {
                    [weak self] success in
                    guard success else {
                        return
                    }
                    self!.performSegue(withIdentifier: "SignOutSegue", sender: self)
                }
            }
        }))
        present(signOutSheet, animated: true)
    }
    
    public func animateButtonPress(buttonToAnimate: UIButton) {
        buttonToAnimate.alpha = 0.5
        buttonToAnimate.backgroundColor = .systemGreen
        UIButton.animate(
            withDuration: 0.5,
            delay: 0,
            animations: {
                buttonToAnimate.backgroundColor = .clear
            })
    }
    
    func presentMessage() {
        let notificationActionSheet = UIAlertController(title: "Notifications not on in System Settings", message: "We will still attempt to send you notifications but you must turn them on in your system settings for them to appear", preferredStyle: .actionSheet)
        notificationActionSheet.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(notificationActionSheet, animated: true)
    }
}
