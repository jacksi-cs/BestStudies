//
//  MemberTableViewCell.swift
//  BestStudies
//
//  Created by Jack Si on 10/25/22.
//

import UIKit

class MemberTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var studyLabel: UILabel!
    @IBOutlet weak var slackLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        nameLabel.font = UIFont(name: "Chalkduster", size: 15)
        nameLabel.textColor = .white
        studyLabel.font = UIFont(name: "Chalkduster", size: 15)
        studyLabel.textColor = .white
        slackLabel.font = UIFont(name: "Chalkduster", size: 15)
        slackLabel.textColor = .white
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
