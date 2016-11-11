//
//  TextAndImageCell.swift
//  NSNewsFeed
//
//  Created by Spaculus MM on 24/08/15.
//  Copyright (c) 2015 Spaculus MM. All rights reserved.
//

import UIKit
import TTTAttributedLabel

class TextAndImageCell: UITableViewCell {

    @IBOutlet var lblTitle: TTTAttributedLabel!
    //@IBOutlet var lblDesc: TTTAttributedLabel!
    @IBOutlet var lblDesc: UILabel!
    @IBOutlet var imgCellDetail: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
