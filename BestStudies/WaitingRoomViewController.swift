//
//  WaitingRoomViewController.swift
//  BestStudies
//
//  Created by Jack Si on 11/8/22.
//

import UIKit

class WaitingRoomViewController: UIViewController {
    
    var connectionManager: ConnectionManager?

    @IBOutlet weak var membersTableView: UITableView!
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var leaveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        connectionManager?.membersTableView = self.membersTableView
        connectionManager?.waitingRoomViewController = self
        membersTableView.delegate = self
        membersTableView.dataSource = self
        
        // Session information variables
        
        
        if connectionManager!.isHosting {
            startButton.isHidden = false
        }

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "chalk.jpeg")!)
        self.membersTableView.backgroundColor = .clear
        let startButtonFont = NSAttributedString(string: "Start Session", attributes: [.foregroundColor: UIColor.cyan, NSAttributedString.Key.font: UIFont(name: "Chalkduster", size: 20)!])
        let leaveButtonFont = NSAttributedString(string: "Leave", attributes: [.foregroundColor: UIColor.cyan, NSAttributedString.Key.font: UIFont(name: "Chalkduster", size: 20)!])
       
        self.startButton.setAttributedTitle(startButtonFont, for: .normal)
        self.leaveButton.setAttributedTitle(leaveButtonFont, for: .normal)
    }
    
    @IBAction func startPressed(_ sender: Any) {
        // TODO: Need to pass on valuable information to waitingroom --> session (isstopwatch, remainingtime, countdownduration, etc.)
        connectionManager?.send(message: "Start")
        performSegue(withIdentifier: "SessionSegueIdentifier", sender: nil)
    }
    
    
    @IBAction func leavePressed(_ sender: Any) {
        connectionManager!.leave()
        self.dismiss(animated: true)
    }
}

extension WaitingRoomViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return connectionManager?.connectedPeers.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemberCell", for: indexPath)
        cell.textLabel?.text = String(describing: connectionManager!.connectedPeers[indexPath.row].displayName)
        cell.textLabel?.font = UIFont(name: "Chalkduster", size: 20)
        cell.textLabel?.textColor = .white
        cell.backgroundColor = .clear
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SessionSegueIdentifier" {
            let destVC = segue.destination as! SessionViewController
            destVC.isStopwatch = connectionManager?.isStopwatch
            destVC.totalTime = connectionManager?.remainingTime
            destVC.connectionManager = self.connectionManager
            destVC.sessionStartTime = Date()
            destVC.joinTimes = Array(repeating: Date(), count: connectionManager?.connectedPeers.count ?? 1)
        }
    }
}
