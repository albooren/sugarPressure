//
//  saveTableViewCell.swift
//  tansiyonSeker
//
//  Created by Alperen Kişi on 25/02/2021.
//

import UIKit

class saveTableViewCell: UITableViewCell {
    @IBOutlet var tansiyonSekerLabel: UILabel!
    @IBOutlet var dateHourLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
