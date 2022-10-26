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
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
