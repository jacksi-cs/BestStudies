//
//  SessionViewController.swift
//  BestStudies
//
//  Created by Jack Si on 10/17/22.
//

// TODO: How do handle when multiple people? How to almost act multithreaded? How to detect when app is still running in foreground but iPhone is closed? Maybe force the app to stay awake?

import UIKit

class SessionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var membersTableView: UITableView!
    
    var members:[String] = []
    var slackTimes:[TimeInterval] = []
    var leaveDates:[Date] = []
    
    var isStopwatch:Bool?
    var totalTime:TimeInterval?
    
    var generalTime:Timer = Timer()
    
    var timeFormatter = DateComponentsFormatter()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        membersTableView.delegate = self
        membersTableView.dataSource = self
        
        totalTime = (totalTime == nil) ? 0 : totalTime
        
        members.append("Yourself")
        slackTimes.append(0.0)
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
            
            if self.isStopwatch! {
                countUp(timePassed: Double(difference.second!))
            } else {
                countDown(timePassed: Double(difference.second!))
            }

        }
        
        if self.isStopwatch! {
            generalTime = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countUpOne), userInfo: nil, repeats: true)
        } else {
            generalTime = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countDownOne), userInfo: nil, repeats: true)
        }
    }
    
    @objc func countUpOne() -> Void {
        totalTime! += 1.0
        self.totalTimeLabel.text = timeFormatter.string(from: totalTime!)
    }
    
    @objc func countDownOne() -> Void {
        totalTime! -= 1.0
        self.totalTimeLabel.text = timeFormatter.string(from: totalTime!)
    }
    
    @objc func countUp(timePassed: Double) -> Void {
        totalTime! += timePassed
        self.totalTimeLabel.text = timeFormatter.string(from: totalTime!)
    }
    
    @objc func countDown(timePassed: Double = 1.0) -> Void {
        totalTime! -= timePassed
        self.totalTimeLabel.text = timeFormatter.string(from: totalTime!)
    }
    
    @objc func countSlack(timePassed: Double, index: Int) -> Void {
        slackTimes[index] += timePassed
        membersTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        members.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = membersTableView.dequeueReusableCell(withIdentifier: "MemberCell", for: indexPath)
        let row = indexPath.row
        cell.textLabel?.text = members[row]
        cell.detailTextLabel?.text = timeFormatter.string(from: slackTimes[row])
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // TODO: For the attempted implementation of mutliple swiping VCs
//        if segue.identifier == "timeSegueIdentifier" {
//            let destVC = segue.destination as! GroupTimeViewController
//
//        }
    }
    
    @IBAction func leavePressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true)
    }
}
