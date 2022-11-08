// Project: NotificationSettingsViewController.swift
// EID: Jac23662
// Course: CS371L


import UIKit

class NotificationSettingsViewController: UIViewController {

    @IBOutlet weak var notificationsOnSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        notificationsOnSwitch.isOn = UserDefaults.standard.bool(forKey: "notificationsOn")
    }

    @IBAction func notificaitonOnSwitchPressed(_ sender: Any) {
        UserDefaults.standard.set(notificationsOnSwitch.isOn, forKey: "notificationsOn")
    }
}
