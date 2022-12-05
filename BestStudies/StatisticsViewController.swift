//
//  StatisticsViewController.swift
//  BestStudies
//
//  Created by Jack Si on 10/17/22.
//

import UIKit

class StatisticsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let tableArray = ["Total Study Time:  1h",
                        "Total Sessions:  15",
                        "Top Study Buddy:  Jack",
                        "Top Study Time:  15m",
                      "Worst Slacking Time  5m",
                        "Worst Study Partner  Jim"]
    
    let cellIdentifier = "StatCellIdentifier"

    @IBOutlet weak var statTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "chalk.jpeg")!)

        // Do any additional setup after loading the view.
        statTableView.delegate = self
        statTableView.dataSource = self
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
