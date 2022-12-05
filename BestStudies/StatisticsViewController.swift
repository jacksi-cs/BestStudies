//
//  StatisticsViewController.swift
//  BestStudies
//
//  Created by Jack Si on 10/17/22.
//

import UIKit

class StatisticsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tableArray = ["Total Study Time:  ",
                      "Total Slack Time: ",
                      "Total Sessions:  ",
                      "Top Study Time:  ",
                      "Worst Slacking Time  ",
                      "Top Study Buddy:  "]
    
    let cellIdentifier = "StatCellIdentifier"
    
    var user: UserStats?
    

    @IBOutlet weak var statTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "chalk.jpeg")!)
        self.statTableView.backgroundColor = .clear
        user = DatabaseManager.shared.getCache()
        updateArray()

        // Do any additional setup after loading the view.
        statTableView.delegate = self
        statTableView.dataSource = self
        statTableView.rowHeight = UITableView.automaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.statTableView.backgroundColor = .clear
        user = DatabaseManager.shared.getCache()
        updateArray()
        self.statTableView.reloadData()

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath as IndexPath)
        let row = indexPath.row
        cell.textLabel?.text = tableArray[row]
        cell.textLabel?.textColor = .white
        cell.backgroundColor = .clear
        return cell
    }
    
    func updateArray() -> Void {
        tableArray[0] = "Total Study Time:  " + "\n" + String(format: "%.2f", user!.studyTime) + " seconds"
        tableArray[1] = "Total Slack Time: " + "\n" + String(format: "%.2f", user!.slackTime) + " seconds"
        tableArray[2] = "Total Sessions:  " + "\n" + String(user!.totalSessions)
        tableArray[3] = "Top Study Time:  " + "\n" + String(format: "%.2f", user!.topStudyTime) + " seconds"
        tableArray[4] = "Worst Slacking Time  " + "\n" + String(format: "%.2f", user!.worstSlackTime) + " seconds"
        tableArray[5] = "Top Study Buddy:  " + "\n" + user!.topBuddy
    }
    

}
