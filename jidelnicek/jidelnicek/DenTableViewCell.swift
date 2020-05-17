//
//  DenTableViewCell.swift
//  jidelnicek
//
//  Created by Hynek Bernard on 11/05/2020.
//  Copyright © 2020 Hynek Bernard. All rights reserved.
//

import UIKit

class DenTableViewCell: UITableViewCell {

    @IBOutlet weak var snidaneLbl: UILabel!
    @IBOutlet weak var vecereLbl: UILabel!
    @IBOutlet weak var obedLbl: UILabel!
    @IBOutlet weak var editBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
