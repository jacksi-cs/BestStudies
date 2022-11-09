//
//  SessionViewController.swift
//  BestStudies
//
//  Created by Jack Si on 10/17/22.
//

// TODO: How do handle when multiple people? How to almost act multithreaded? How to detect when app is still running in foreground but iPhone is closed? Maybe force the app to stay awake?

import UIKit

class SessionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {


    @IBOutlet weak var totalTimeElapsedLabel: UILabel! // Time elapsed
    @IBOutlet weak var totalTimeRemainingLabel: UILabel! // Time remaining
    @IBOutlet weak var membersTableView: UITableView!

    var members:[String] = [] // List of group member names
    var studyTimers:[Timer] = [] // TODO: Might be able to, in the future, not have individual timers but just stop incrementing individuals studyTimes when off; or keep track of initial room join time and calculate studyTimes with (current time - join time) - total slack time
    var studyTimes:[TimeInterval] = [] // List of each group member's total study time
    var slackTimes:[TimeInterval] = [] // List of each group member's total slacking time
    var leaveDates:[Date] = [] // List of each group member's latest 'left the app' time, used to calculate slack times

    var isStopwatch:Bool?
    var remainingTime:TimeInterval? // Decrements from total session time or does not show
    var elapsedTime:TimeInterval = 0.0 // Increments from 0

    var generalTime:Timer = Timer()

    var timeFormatter = DateComponentsFormatter()



    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)

        membersTableView.delegate = self
        membersTableView.dataSource = self
        
        members.append("Yourself")
        slackTimes.append(0.0)
        studyTimes.append(0.0)
        studyTimers.append(Timer())
        leaveDates.append(Date())

        timeFormatter.unitsStyle = .abbreviated
        timeFormatter.zeroFormattingBehavior = .pad
        timeFormatter.allowedUnits = [.hour, .minute, .second]

        NotificationCenter.default.addObserver(forName: UIApplication.didEnterBackgroundNotification, object: nil, queue: nil) { [self](notification) in
            leaveDates[0] = Date()
        }

        NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: nil) { [self](notification) in
            let difference = Calendar.current.dateComponents([.second], from: leaveDates[0], to: Date())
            updateSlackTime(timePassed: Double(difference.second!), index: 0) // TODO: Statically calling index 0 for now, needs to be dynamic when implement multipeer
            
            updateGeneralTime(timePassed: Double(difference.second!))
        }
        
        generalTime = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(incrementGeneralTime), userInfo: nil, repeats: true)
        
        // TODO: Currently sets all members' study timers locally, when implementing multipeer probably needs to be done separately
        for index in studyTimers.indices {
            studyTimers[index] = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(incrementStudyTime), userInfo: index, repeats: true)
        }
    }
    
    // TODO: Stopping a little slow
    // Called every second by studyTimers to increment a member's study time
    @objc func incrementStudyTime(timer:Timer) -> Void {
        studyTimes[timer.userInfo as! Int] += 1.0
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

    // Called after exiting and reenteringthe app to update a member's slack time
    @objc func updateSlackTime(timePassed: Double, index: Int) -> Void {
        slackTimes[index] += timePassed
        membersTableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        members.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = membersTableView.dequeueReusableCell(withIdentifier: "MemberCell", for: indexPath) as! MemberTableViewCell
        let row = indexPath.row
        cell.nameLabel?.text = members[row]
        cell.slackLabel?.text = timeFormatter.string(from: slackTimes[row])
        cell.studyLabel?.text = timeFormatter.string(from: studyTimes[row])
        return cell
    }

    @IBAction func leavePressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        generalTime.invalidate()
        
        for studyTimer in studyTimers {
            studyTimer.invalidate()
        }
        
        dismiss(animated: true)
    }
}
