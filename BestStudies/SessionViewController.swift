//
//  SessionViewController.swift
//  BestStudies
//
//  Created by Jack Si on 10/17/22.
//

// TODO: When non host leaves, all devices will force members = connectedPeers so that tableView updates (HOWEVER corresponding studyTimes and slackTimes and studyTimers are NOT being removed)

import UIKit
import MultipeerConnectivity

class SessionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var totalTimeElapsedLabel: UILabel! // Time elapsed
    @IBOutlet weak var totalTimeRemainingLabel: UILabel! // Time remaining
    @IBOutlet weak var membersTableView: UITableView!

    var members:[MCPeerID]? // List of group member names
    var studyTimers:[Timer]? // TODO: Might be able to, in the future, not have individual timers but just stop incrementing individuals studyTimes when off; or keep track of initial room join time and calculate studyTimes with (current time - join time) - total slack time
    var studyTimes:[TimeInterval]? // List of each group member's total study time
    var slackTimes:[TimeInterval]? // List of each group member's total slacking time
    var leaveDates:[Date]? // List of each group member's latest 'left the app' time, used to calculate slack times

    var isStopwatch:Bool?
    var remainingTime:TimeInterval? // Decrements from total session time or does not show
    var elapsedTime:TimeInterval = 0.0 // Increments from 0

    var generalTime:Timer = Timer()

    var timeFormatter = DateComponentsFormatter()
    
    var connectionManager: ConnectionManager?
    var otherDeviceStatus: [Bool]? // Array of other devices and whether they are on or off the app (true or false); index 0 is your device status which is not updated or used
    var indexDict:[MCPeerID:Int]? // Dictionary of key: peerID, values: index

    override func viewDidLoad() {
        print("VIEW DID LOAD CALLED")
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        
        connectionManager?.sessionViewController = self

        membersTableView.delegate = self
        membersTableView.dataSource = self

        
        // TODO: Add semaphore for shared variables for threadsafe capabilities
        members = connectionManager?.connectedPeers
        indexDict = Dictionary(uniqueKeysWithValues: zip(members!, Array(0...members!.count-1)))
        slackTimes = Array(repeating: 0.0, count: connectionManager?.connectedPeers.count ?? 1)
        studyTimes = Array(repeating: 0.0, count: connectionManager?.connectedPeers.count ?? 1)
        studyTimers = Array(repeating: Timer(), count: connectionManager?.connectedPeers.count ?? 1)
        leaveDates = Array(repeating: Date(), count: connectionManager?.connectedPeers.count ?? 1)
        otherDeviceStatus = Array(repeating: true, count: connectionManager?.connectedPeers.count ?? 1)

        timeFormatter.unitsStyle = .abbreviated
        timeFormatter.zeroFormattingBehavior = .pad
        timeFormatter.allowedUnits = [.hour, .minute, .second]

        NotificationCenter.default.addObserver(forName: UIApplication.didEnterBackgroundNotification, object: nil, queue: nil) { [self](notification) in
            self.connectionManager?.send(message: "False")
            leaveDates![0] = Date()
        }

        NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: nil) { [self](notification) in
            self.connectionManager?.send(message: "True")
            let difference = Calendar.current.dateComponents([.second], from: leaveDates![0], to: Date())
            updateSlackTime(timePassed: Double(difference.second!), index: 0)
            
            updateGeneralTime(timePassed: Double(difference.second!))
        }
        
        generalTime = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(incrementGeneralTime), userInfo: nil, repeats: true)
        
        // Creating timers for every member
        for index in studyTimers!.indices {
            studyTimers![index] = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(incrementStudyTime), userInfo: index, repeats: true)
        }
    }
    
    // Called after a non-host leaves, allowing other devices to clean up variables corresponding to that left member
    func updatingVariables(index: Int) {
        print("UPDATING VARIABLES CALLED")
        indexDict = Dictionary(uniqueKeysWithValues: zip(members!, Array(0...members!.count-1)))
        slackTimes!.remove(at: index)
        studyTimes!.remove(at: index)
        studyTimers![index].invalidate()
        studyTimers!.remove(at: index)
        leaveDates!.remove(at: index)
        otherDeviceStatus!.remove(at: index)
    }
    
    
    
    // TODO: Stopping a little slow
    // Called every second by studyTimers to increment a member's study time
    @objc func incrementStudyTime(timer:Timer) -> Void {
        if ((timer.userInfo as! Int) == 1) {
            print("Timer is incrementing properly!")
        }
        studyTimes![timer.userInfo as! Int] += 1.0
        membersTableView.reloadData()
    }

    // Called every second by generalTimer to update the general remaining (if timer) and elapsed times
    @objc func incrementGeneralTime() -> Void {
        if !(isStopwatch!) {
            remainingTime! -= 1.0
             self.totalTimeRemainingLabel.text = timeFormatter.string(from: remainingTime!)
        }
        elapsedTime += 1.0
        self.totalTimeElapsedLabel.text =  timeFormatter.string(from: elapsedTime)
    }

    // Called after exiting and reentering the app to update the general remaining (if timer) and elapsed times
    @objc func updateGeneralTime(timePassed: Double) -> Void {
        if !(isStopwatch!) {
            remainingTime! -= timePassed
            self.totalTimeRemainingLabel.text = timeFormatter.string(for: remainingTime!)
        }
        elapsedTime += timePassed
        self.totalTimeElapsedLabel.text = timeFormatter.string(from: elapsedTime)
    }

    // Called after exiting and reentering the app to update a member's slack time
    @objc func updateSlackTime(timePassed: Double, index: Int) -> Void {
        slackTimes![index] += timePassed
//        membersTableView.reloadData()
        if index == 0 {
            // TODO: Have to check to update other timers if they are still studying; true (apps still on) + timePassed to their studytimes
            if otherDeviceStatus!.count > 1 {
                for i in 1...otherDeviceStatus!.endIndex-1 {
                    if otherDeviceStatus![i] == true {
                        studyTimes![i] += timePassed
                    }
                }
            }
        }
        DispatchQueue.main.async {
            self.membersTableView.reloadData()
        }
    }
    
    // TODO: Change status of device --> false = change leave date and pause timer, true = calculate time passed and update slacktime start up timer
    func updateOtherDeviceStatus(index: Int, value: Bool) {
        if (otherDeviceStatus![index] != !value) {
            print("BIG TROUBLE UH OH")
        }
        otherDeviceStatus![index] = value
        if value == false {
            leaveDates![index] = Date()
            studyTimers![index].invalidate()
        } else {
            print("\(value), \(index)")
            let difference = Calendar.current.dateComponents([.second], from: leaveDates![index], to: Date())
            updateSlackTime(timePassed: Double(difference.second!), index: index)
            DispatchQueue.main.async {
                self.studyTimers![index] = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.incrementStudyTime), userInfo: index, repeats: true)
            }
            print("Timer rescheduled \(studyTimers![index])")
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        members!.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = membersTableView.dequeueReusableCell(withIdentifier: "MemberCell", for: indexPath) as! MemberTableViewCell
        let row = indexPath.row
        cell.nameLabel?.text = members![row].displayName
        cell.slackLabel?.text = timeFormatter.string(from: slackTimes![row])
        cell.studyLabel?.text = timeFormatter.string(from: studyTimes![row])
        return cell
    }

    @IBAction func leavePressed(_ sender: Any) {
//        navigationController?.popViewController(animated: true)
        generalTime.invalidate()
        
        for studyTimer in studyTimers! {
            studyTimer.invalidate()
        }
        
        members = nil // List of group member names
        studyTimers = nil // TODO: Might be able to, in the future, not have individual timers but just stop incrementing individuals studyTimes when off; or keep track of initial room join time and calculate studyTimes with (current time - join time) - total slack time
        studyTimes = nil // List of each group member's total study time
        slackTimes = nil // List of each group member's total slacking time
        leaveDates = nil
        otherDeviceStatus = nil
        
        connectionManager!.leave()
        
//        dismiss(animated: true)
    }
}
