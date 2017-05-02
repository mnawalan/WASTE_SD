//
//  IconTableViewCell.swift
//  3-20-client
//
//  Created by Mary Kate Nawalaniec on 5/1/17.
//  Copyright © 2017 Mary Kate Nawalaniec. All rights reserved.
//

import UIKit

class IconTableViewCell: UITableViewCell {

    @IBOutlet weak var checkmarkImageView: UIImageView!
    @IBOutlet weak var iconImageView: UIImageView!
    
    var cellSelected: Bool = false
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.checkmarkImageView.isHidden = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

//        // Configure the view for the selected state
//        self.checkmarkImageView.isHidden = false
//        self.iconImageView.alpha = CGFloat(0.8)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
       self.iconImageView.frame = CGRect(x:0.0,y:0.0,width:80.0,height:40.0)
        self.iconImageView.contentMode = .scaleAspectFit
    }
    
    

}
