// Project: NotificationSettingViewController.swift
// EID: Jac23662
// Course: CS371L


import UIKit

class NotificationSettingViewController: UIViewController {

    @IBOutlet weak var notificationsOnSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        notificationsOnSwitch.isOn = UserDefaults.standard.bool(forKey: "notificationsOn")
    }

    @IBAction func notificaitonOnSwitchPressed(_ sender: Any) {
        UserDefaults.standard.set(notificationsOnSwitch.isOn, forKey: "notificationsOn")
        let current = UNUserNotificationCenter.current()
        let notificationsOn = self.notificationsOnSwitch.isOn
        current.getNotificationSettings { settings in
            if(settings.authorizationStatus == .denied && notificationsOn) {
                DispatchQueue.main.async {
                    self.presentMessage()
                }

            }
        }

    }
    
    func presentMessage() {
        let notificationActionSheet = UIAlertController(title: "Notifications not on in System Settings", message: "We will still attempt to send you notifications but you must turn them on in your system settings for them to appear", preferredStyle: .actionSheet)
        notificationActionSheet.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(notificationActionSheet, animated: true)
    }
}
