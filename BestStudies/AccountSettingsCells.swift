// Project: AccountSettingsCells.swift
// EID: Jac23662
// Course: CS371L


import Foundation

import UIKit

class AccountSettingsCells: UITableViewCell {

    @IBOutlet weak var userNameCell: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
