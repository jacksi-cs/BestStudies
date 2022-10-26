//
//  SessionViewController.swift
//  BestStudies
//
//  Created by Jack Si on 10/17/22.
//

// TODO: How do handle when multiple people? How to almost act multithreaded? How to detect when app is still running in foreground but iPhone is closed? Maybe force the app to stay awake?

import UIKit

class SessionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {


    @IBOutlet weak var totalTimeLabel: UILabel! // Time elapsed
    @IBOutlet weak var totalTimeRemainingLabel: UILabel! // Time remaining
    @IBOutlet weak var membersTableView: UITableView!

    var members:[String] = []
    var slackTimes:[TimeInterval] = []
    var studyTimers:[Timer] = [] // TODO: Might be able to, in the future, not have individual timers but just stop incrementing individuals studyTimes when off
    var studyTimes:[TimeInterval] = []
    var leaveDates:[Date] = []

    var isStopwatch:Bool?
    var totalTime:TimeInterval? // Decrements from total session time or does not show
    var countingTime:TimeInterval = 0.0 // Increments

    var generalTime:Timer = Timer()

    var timeFormatter = DateComponentsFormatter()



    override func viewDidLoad() {
        super.viewDidLoad()

        membersTableView.delegate = self
        membersTableView.dataSource = self

//        totalTime = (totalTime == nil) ? 0 : totalTime

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
            countSlack(timePassed: Double(difference.second!), index: 0)

//            if self.isStopwatch! {
//                countUp(timePassed: Double(difference.second!))
//            } else {
//                countDown(timePassed: Double(difference.second!))
//            }
            
            countUp(timePassed: Double(difference.second!))
        }

//        if self.isStopwatch! {
//            generalTime = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countUpOne), userInfo: nil, repeats: true)
//        } else {
//            generalTime = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countDownOne), userInfo: nil, repeats: true)
//        }
        generalTime = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countUpOne), userInfo: nil, repeats: true)
        
        for index in studyTimers.indices {
            studyTimers[index] = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countUpOneStudy), userInfo: index, repeats: true)
        }
    }
    
    // TODO: Stopping a little slow
    @objc func countUpOneStudy(timer:Timer) -> Void {
        studyTimes[timer.userInfo as! Int] += 1.0
        membersTableView.reloadData()
    }

    @objc func countUpOne() -> Void {
        if !(isStopwatch!) {
            totalTime! -= 1.0
             self.totalTimeRemainingLabel.text = timeFormatter.string(from: totalTime!)
        }
        countingTime += 1.0
        self.totalTimeLabel.text =  timeFormatter.string(from: countingTime)
    }

//    @objc func countDownOne() -> Void {
//        totalTime! -= 1.0
//        self.totalTimeLabel.text = timeFormatter.string(from: totalTime!)
//    }

    // Counting the difference when gone and adding it to the general timers
    @objc func countUp(timePassed: Double) -> Void {
        if !(isStopwatch!) {
            totalTime! -= timePassed
            self.totalTimeRemainingLabel.text = timeFormatter.string(for: totalTime!)
        }
        countingTime += timePassed
        self.totalTimeLabel.text = timeFormatter.string(from: totalTime!)
    }

//    @objc func countDown(timePassed: Double = 1.0) -> Void {
//        totalTime! -= timePassed
//        self.totalTimeLabel.text = timeFormatter.string(from: totalTime!)
//    }

    @objc func countSlack(timePassed: Double, index: Int) -> Void {
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
//            studyTimer = Timer()
        }
        
        dismiss(animated: true)
    }
}
