//
//  SessionViewController.swift
//  BestStudies
//
//  Created by Jack Si on 10/17/22.
//

// TODO: When non host leaves, all devices will force members = connectedPeers so that tableView updates (HOWEVER corresponding studyTimes and slackTimes and studyTimers are NOT being removed)

import UIKit
import MultipeerConnectivity
import AVFoundation

class SessionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var totalTimeElapsedLabel: UILabel! // Time elapsed
    @IBOutlet weak var totalTimeRemainingLabel: UILabel! // Time remaining
    @IBOutlet weak var membersTableView: UITableView!
    @IBOutlet weak var leaveButton: UIButton!
    
    var members:[MCPeerID]? // List of group member names
    
    var joinTimes:[Date]?
    var studyTimers:Timer? // TODO: Might be able to, in the future, not have individual timers but just stop incrementing individuals studyTimes when off; or keep track of initial room join time and calculate studyTimes with (current time - join time) - total slack time
    var studyTimes:[TimeInterval]? // List of each group member's total study time
    var slackTimes:[TimeInterval]? // List of each group member's total slacking time
    var prevSlackTimes:[TimeInterval]?
    var leaveDates:[Date]? // List of each group member's latest 'left the app' time, used to calculate slack times
    
    var leaveObserver:NSObjectProtocol?
    var comeBackObserver:NSObjectProtocol?
    var nameArray: Array<String> = []

    var isStopwatch:Bool?
    var totalTime:TimeInterval!
//    var remainingTime:TimeInterval? // Decrements from total session time or does not show
    var elapsedTime:TimeInterval = 0.0 // Increments from 0
    var sessionStartTime:Date!

    var generalTimer:Timer = Timer()

    var timeFormatter = DateComponentsFormatter()
    
    var connectionManager: ConnectionManager?
    var otherDeviceStatus: [Bool]? // Array of other devices and whether they are on or off the app (true or false); index 0 is your device own status (indexing matches connectionManager.connectedPeers)
    var indexDict:[MCPeerID:Int]? // Dictionary of key: peerID, values: index

    override func viewDidLoad() {
        super.viewDidLoad()
        
        connectionManager?.sessionViewController = self

        membersTableView.delegate = self
        membersTableView.dataSource = self
        
        totalTimeElapsedLabel.font = UIFont(name: "Chalkduster", size: 20)
        totalTimeElapsedLabel.textColor = .white

        if !isStopwatch! {
            totalTimeRemainingLabel.isHidden = false
            totalTimeRemainingLabel.font = UIFont(name: "Chalkduster", size: 20)
            totalTimeRemainingLabel.textColor = .white
        } else {
            totalTimeRemainingLabel.isHidden = true
        }
        
        // TODO: Add semaphore for shared variables for threadsafe capabilities
        members = connectionManager?.connectedPeers
        indexDict = Dictionary(uniqueKeysWithValues: zip(members!, Array(0...members!.count-1)))
        slackTimes = Array(repeating: 0.0, count: connectionManager?.connectedPeers.count ?? 1)
        prevSlackTimes = Array(repeating: 0.0, count: connectionManager?.connectedPeers.count ?? 1)
        studyTimes = Array(repeating: 0.0, count: connectionManager?.connectedPeers.count ?? 1)
//        studyTimers = Array(repeating: Timer(), count: connectionManager?.connectedPeers.count ?? 1)
        leaveDates = Array(repeating: Date(), count: connectionManager?.connectedPeers.count ?? 1)
        otherDeviceStatus = Array(repeating: true, count: connectionManager?.connectedPeers.count ?? 1)

        timeFormatter.unitsStyle = .abbreviated
        timeFormatter.zeroFormattingBehavior = .pad
        timeFormatter.allowedUnits = [.hour, .minute, .second]
        
        leaveObserver = NotificationCenter.default.addObserver(forName: UIApplication.didEnterBackgroundNotification, object: nil, queue: nil) { [self](notification) in
            
            let session = AVAudioSession.sharedInstance()
                    do {
                        try session.setCategory(AVAudioSession.Category.playback,
                                                mode: AVAudioSession.Mode.default,
                                                options: [AVAudioSession.CategoryOptions.mixWithOthers])
                        try session.setPrefersNoInterruptionsFromSystemAlerts(true)
                        try session.setActive(true)
                    } catch let error as NSError {
                        print("Failed to set the audio session category and mode: \(error.localizedDescription)")
                    }
            
            print("\(self.leaveDates!) \(Thread.current) left in background")
            self.otherDeviceStatus![0] = false
            self.connectionManager?.send(message: "False")
            self.leaveDates![0] = Date()
        }

        comeBackObserver = NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: nil) { [self](notification) in
            self.connectionManager?.send(message: "True")
            self.otherDeviceStatus![0] = true
            let difference = Calendar.current.dateComponents([.second], from: leaveDates![0], to: Date())
            updateSlackTime(timePassed: Double(difference.second!), index: 0)
        }
        
        generalTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(incrementGeneralTime), userInfo: nil, repeats: true)
        
        // Creating timers for every member
        studyTimers = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(incrementStudyTime), userInfo: nil, repeats: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "chalk.jpeg")!)
        self.membersTableView.backgroundColor = .clear
        let leaveButtonFont = NSAttributedString(string: "Leave", attributes: [.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont(name: "Chalkduster", size: 20)!])
        self.leaveButton.setAttributedTitle(leaveButtonFont, for: .normal)
    }
    
    // Called after a non-host leaves, allowing other devices to clean up variables corresponding to that left member
    func updatingVariables(index: Int) {
        print("UPDATING VARIABLES CALLED")
        indexDict = Dictionary(uniqueKeysWithValues: zip(members!, Array(0...members!.count-1)))
        slackTimes!.remove(at: index)
        studyTimes!.remove(at: index)
//        studyTimers![index].invalidate()
//        studyTimers!.invalidate()
//        studyTimers!.remove(at: index)
        leaveDates!.remove(at: index)
        otherDeviceStatus!.remove(at: index)
    }
    
    
    
    // TODO: Stopping a little slow
    // Called every second by studyTimers to increment a member's study time
    @objc func incrementStudyTime(timer:Timer) -> Void {
        // TODO: Now updates study time of everyone (does not need index arg); additionally computes slack times real time if device is away
        for i in 0...otherDeviceStatus!.endIndex-1 {
            if otherDeviceStatus![i] == true {
                studyTimes![i] = (Date() - joinTimes![i]) - slackTimes![i]
            } else if otherDeviceStatus![i] == false {
                slackTimes![i] = prevSlackTimes![i] + (Date() - leaveDates![i])
            }
        }
        
        membersTableView.reloadData()
    }

    // Called every second by generalTimer to update the general remaining (if timer) and elapsed times
    @objc func incrementGeneralTime() -> Void {
        elapsedTime = Date() - self.sessionStartTime
        self.totalTimeElapsedLabel.text = "Elapsed:  \(timeFormatter.string(from: elapsedTime.rounded())!)"
        
        if !(isStopwatch!) {
            let remainingTime = totalTime - elapsedTime
            self.totalTimeRemainingLabel.text = "Remaining:  \(timeFormatter.string(from: remainingTime.rounded())!)"
        }
    }

    // Called after exiting and reentering the app to update the general remaining (if timer) and elapsed times
//    @objc func updateGeneralTime(timePassed: Double) -> Void {
//        if !(isStopwatch!) {
//            remainingTime! -= timePassed
//            self.totalTimeRemainingLabel.text = timeFormatter.string(for: remainingTime!)
//        }
//        elapsedTime += timePassed
//        self.totalTimeElapsedLabel.text = timeFormatter.string(from: elapsedTime)
//    }

    // Called after exiting and reentering the app to update a member's slack time
    @objc func updateSlackTime(timePassed: Double, index: Int) -> Void {
        print("index: \(index), prevSlackTime: \(prevSlackTimes![index]), slackTime: \(timePassed)")
        prevSlackTimes![index] += timePassed
        slackTimes![index] = prevSlackTimes![index]
//        membersTableView.reloadData()
//        if index == 0 {
//            // TODO: Have to check to update other timers if they are still studying; true (apps still on) + timePassed to their studytimes
//            if otherDeviceStatus!.count > 1 {
//                for i in 1...otherDeviceStatus!.endIndex-1 {
//                    if otherDeviceStatus![i] == true {
//                        studyTimes![i] += timePassed
//                    }
//                }
//            }
//        }
        DispatchQueue.main.async {
            self.membersTableView.reloadData()
        }
    }
    
    // TODO: Change status of device --> false = change leave date and pause timer, true = calculate time passed and update slacktime start up timer
    // Called from Connection Manager when host determines session settings and must communicate it to other devices
    func updateOtherDeviceStatus(index: Int, value: Bool) {
        if (otherDeviceStatus![index] != !value) {
            print("BIG TROUBLE UH OH")
        }
        
        otherDeviceStatus![index] = value
        print("\(index), \(value)")
        
        if value == false {
            leaveDates![index] = Date()
//            studyTimers![index].invalidate()
        } else if value {
            print("\(value), \(index)")
            
            // TODO: IMPORTANT THINGS COMMENTED OUT, TRYING TO UPDATE OTHER DEVICE SLACK TIMES THROUGH INCREMENT STUDY TIME FUNCTION
            let difference = Calendar.current.dateComponents([.second], from: leaveDates![index], to: Date())
            updateSlackTime(timePassed: Double(difference.second!), index: index)
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        members!.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = membersTableView.dequeueReusableCell(withIdentifier: "MemberCell", for: indexPath) as! MemberTableViewCell
        let row = indexPath.row
        cell.nameLabel?.text = members![row].displayName
        if members![row].displayName != AuthManager.shared.getCurrentUser() {
            nameArray.append(members![row].displayName)
        }
        
        cell.slackLabel?.text = timeFormatter.string(from: slackTimes![row])
        cell.studyLabel?.text = timeFormatter.string(from: studyTimes![row])
        cell.backgroundColor = .clear
        return cell
    }

    @IBAction func leavePressed(_ sender: Any) {
        NotificationCenter.default.removeObserver(leaveObserver!, name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.removeObserver(comeBackObserver!, name: UIApplication.willEnterForegroundNotification, object: nil)
        
        print("leave pressed \(Date.now)")
        generalTimer.invalidate()
        
        studyTimers!.invalidate()
//        for studyTimer in studyTimers! {
//            studyTimer.invalidate()
//        }
        DatabaseManager.shared.updateStats(studyTime: studyTimes![0], slackTime: slackTimes![0], names: nameArray)
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

extension Date {
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
}
