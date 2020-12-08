//
//  RecentSpaceTableViewCell.swift
//  HoldTheSpace
//
//  Created by Mac on 4/18/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit

class RecentSpaceTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//        layer.masksToBounds = false
//        layer.cornerRadius = Constants.cornerRadius
        
        
        
    }
    
    
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var descriptionLbl: UILabel!
    
    @IBOutlet weak var priceLbl: UILabel!
    
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    
}
