//
//  SpaceTableViewCell.swift
//  HoldThatSpace
//
//  Created by Mac on 4/16/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit
protocol SpaceDelegate {
    func paymentForSpace(sprice : String , sTitle : String )
}

class SpaceTableViewCell: UITableViewCell {

    
    
    var delegate : SpaceDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    
//        holdThatSpaceBtn.backgroundColor = UIColor.blue
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    


    
    
    
    @IBOutlet weak var imageOfProfile: UIImageView!
    

    @IBOutlet weak var priceLbl: UILabel!
    
    @IBOutlet weak var holdThatSpaceBtn: UIButton!
   
    @IBOutlet weak var spaceTitleLbl: UILabel!
    
    
    
    
    
    
    
    @IBAction func holdThatSpaceBtnClicked(_ sender: Any) {
    
        delegate?.paymentForSpace(sprice: self.priceLbl.text!, sTitle : self.spaceTitleLbl.text!)
    
    }
    
}
