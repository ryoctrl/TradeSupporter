//
//  InformationCell.swift
//  TradeSupporter
//
//  Created by mosin on 2017/12/28.
//  Copyright © 2017年 mosin. All rights reserved.
//

import UIKit

class InformationCell: UITableViewCell {

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
