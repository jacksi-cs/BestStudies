//
//  SettingsViewController.swift
//  BestStudies
//
//  Created by Jack Si on 10/17/22.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let settings = ["Account", "Sound", "Notifications", "Linking"]
    
    let cellIdentifier = "SettingCellIdentifier"
    
    @IBOutlet weak var settingsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingsTable.delegate = self
        settingsTable.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath as IndexPath)
        let row = indexPath.row
        cell.textLabel?.text = settings[row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        settingsTable.deselectRow(at: indexPath, animated: true)
        SoundManager.shared.playButtonSound(sound: .chillButton)
        switch indexPath.row {
        case 0:
            self.performSegue(withIdentifier: "AccountSettingsSegue", sender: self)
        case 1:
            self.performSegue(withIdentifier: "SoundSettingsSegue", sender: self)
        default:
            print("Hit default case in settings switch");
        }
    }
}
