//
//  HomeViewController.swift
//  BestStudies
//
//  Created by Jack Si on 10/17/22.
//

import UIKit

class HomeViewController: UIViewController {
    
    var connectionManager:ConnectionManager = ConnectionManager()
    
    @IBOutlet weak var createSession: UIButton!
    @IBOutlet weak var joinSession: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "chalk.jpeg")!)
        
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont(name: "Chalkduster", size: 20)!]
        
//        createSession.titleLabel?.font = UIFont(name: "Chalkduster", size: 30)
//        createSession.setTitleColor(UIColor.white, for: .normal)
//        
//        joinSession.titleLabel?.font = UIFont(name: "Chalkduster", size: 30)
//        joinSession.setTitleColor(UIColor.white, for: .normal)
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.isTranslucent = true
//        self.navigationController?.view.backgroundColor = .clear
        DatabaseManager.shared.getStats {
            [weak self] success in
            guard success else {
                return
            }
        }
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
    
    @IBAction func helpButtonPressed(_ sender: Any) {
        let controller = UIAlertController(
            title: "How To!",
            message: """
                    When you're ready to study, you have a few session options to choose from. \n\nWhen creating a session, you are able to choose between  stopwatch and timer mode. Ready to see how long you can focus? Start up a stopwatch session! Need to grind for a set amount of time? Set how long you want the session to last. \n\nGet together with friends or teammates for group productivity. Joining a session is super easy with Peer Connectivity. When you're near your friends, add who you would like to be in your session. When you're in the virtual study room, you'll be able to see everyone present!
                    """,
            preferredStyle: .alert)
        
        controller.addAction(UIAlertAction(
            title: "Dismiss",
            style: .cancel,
            handler: {
                (paramAction:UIAlertAction!) in
                
                
            }))
        
        present(controller, animated: true)
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
