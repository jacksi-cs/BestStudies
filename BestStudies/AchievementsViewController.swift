//
//  AchievementsViewController.swift
//  BestStudies
//
//  Created by Jack Si on 10/17/22.
//

import UIKit

class AchievementsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let tableArray = ["Best Studier: \n Study for 30 seconds in a session.",
                        "Group Studier:  \n Study with 1 or more friends.",
                        "Frequent Studier:  \n Study for longer than 1 minute cumulatively"]
    
    let cellIdentifier = "AchieveCellIdentifier"
    
    var user: UserStats?

    @IBOutlet weak var achieveTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "chalk.jpeg")!)
        self.achieveTableView.backgroundColor = .clear
        // Do any additional setup after loading the view.
        achieveTableView.delegate = self
        achieveTableView.dataSource = self
        user = DatabaseManager.shared.getCache()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        user = DatabaseManager.shared.getCache()
        achieveTableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath as IndexPath)
        let row = indexPath.row
        cell.textLabel?.text = tableArray[row]
        cell.textLabel?.textColor = .gray
        cell.backgroundColor = .clear
        switch row {
        case 0:
            if user!.studyTime >= 60 {
                cell.textLabel?.textColor = .green
            }
        case 1:
            if user!.userDict.count >= 1 {
                cell.textLabel?.textColor = .green
            }
        case 2:
            if user!.topStudyTime >= 30 {
                cell.textLabel?.textColor = .green
            }
        default:
            break
        }
        
        return cell
    }
}
