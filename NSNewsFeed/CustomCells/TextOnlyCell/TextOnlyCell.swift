//
//  TextOnlyCell.swift
//  NSNewsFeed
//
//  Created by Naeem Shaikh on 24/08/15.
//  Copyright (c) 2015 Naeem Shaikh. All rights reserved.
//

import UIKit
import Foundation
import TTTAttributedLabel


class TextOnlyCell: UITableViewCell {

    @IBOutlet var imgCell: UIImageView!
    @IBOutlet var lblTitle: TTTAttributedLabel!
    @IBOutlet var lblDesc: TTTAttributedLabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
