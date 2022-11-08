//
//  HomeViewController.swift
//  BestStudies
//
//  Created by Jack Si on 10/17/22.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        presentNotificationPrompt()

    }

    @IBAction func createButtonPressed(_ sender: Any) {
        SoundManager.shared.playButtonSound(sound: .chillButton)
    }
    
    @IBAction func joinButtonPressed(_ sender: Any) {
        SoundManager.shared.playButtonSound(sound: .chillButton)
    }
    
    func presentNotificationPrompt() {
        let current = UNUserNotificationCenter.current()
        current.getNotificationSettings { settings in
            if(settings.authorizationStatus == .denied || settings.authorizationStatus == .notDetermined) {
                UNUserNotificationCenter.current().requestAuthorization(options:[.alert,.badge,.sound]) {
                    granted, error in
                    if granted {
                        print("All set!")
                    } else if let error = error {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
}
