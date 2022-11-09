//
//  HomeViewController.swift
//  BestStudies
//
//  Created by Jack Si on 10/17/22.
//

import UIKit

class HomeViewController: UIViewController {
    
    var connectionManager:ConnectionManager = ConnectionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)

        connectionManager.homeViewController = self
        
        // Do any additional setup after loading the view.
        presentNotificationPrompt()
        
    }
    
    @IBAction func createButtonPressed(_ sender: Any) {
        SoundManager.shared.playButtonSound(sound: .chillButton)
        performSegue(withIdentifier: "CreateSessionSegueIdentifier", sender: nil)
        
    }
    
    @IBAction func joinButtonPressed(_ sender: Any) {
        SoundManager.shared.playButtonSound(sound: .chillButton)
        connectionManager.join()
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "WaitingRoomSegueIdentifier1" {
            let destVC = segue.destination as! WaitingRoomViewController
            destVC.connectionManager = self.connectionManager
            // TODO: Need to pass on valuable information to waitingroom --> session (isstopwatch, remainingtime, countdownduration, etc.)
        }
    }
}
