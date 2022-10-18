//
//  GroupTimeViewController.swift
//  BestStudies
//
//  Created by Jack Si on 10/17/22.
//

import UIKit

let groupTimes = ["Hello", "Bye bye"]
let descriptors = ["John", "Mary"]

class GroupTimesCell: UICollectionViewCell {
    
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var descriptor: UILabel!
    
    public func configure(time: String, descriptor: String) {
        self.time.text = time
        self.descriptor.text = descriptor
    }
}

class GroupTimeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var groupTimesCollection: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        groupTimesCollection.dataSource = self
        groupTimesCollection.delegate = self
            
        groupTimesCollection.register(UINib.init(nibName: "GroupTimesCell", bundle: nil), forCellWithReuseIdentifier: "GroupTimesCell")

        // Do any additional setup after loading the view.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        groupTimes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = groupTimesCollection.dequeueReusableCell(withReuseIdentifier: "GroupTimesCell", for: indexPath) as! GroupTimesCell
        let row = indexPath.row
        cell.configure(time: groupTimes[row], descriptor: descriptors[row])
        switch row {
        case 0:
            cell.backgroundColor = .black
        case 1:
            cell.backgroundColor = .blue
        default:
            cell.backgroundColor = .white
        }
        
        
        return cell
    }

}
