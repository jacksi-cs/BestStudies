//
//  AchievementsViewController.swift
//  BestStudies
//
//  Created by Jack Si on 10/17/22.
//

import UIKit

class AchievementsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let tableArray = ["Best Studier: \n Study more than anyone else in a group.",
                        "Group Studier:  \n Study with 5 or more friends in a single session.",
                        "Frequent Studier:  \n Study for longer than 1 hour cumulatively"]
    
    let cellIdentifier = "AchieveCellIdentifier"

    @IBOutlet weak var achieveTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)

        // Do any additional setup after loading the view.
        achieveTableView.delegate = self
        achieveTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath as IndexPath)
        let row = indexPath.row
        cell.textLabel?.text = tableArray[row]
        cell.backgroundColor = .white
        return cell
    }
}
