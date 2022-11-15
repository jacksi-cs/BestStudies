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
