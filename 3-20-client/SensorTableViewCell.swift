//
//  SensorTableViewCell.swift
//  3-20-client
//
//  Created by Mary Kate Nawalaniec on 4/28/17.
//  Copyright © 2017 Mary Kate Nawalaniec. All rights reserved.
//

import UIKit

class SensorTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var backgroundLabel: UILabel!
    @IBOutlet weak var sensorContent: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var sensorImage: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    let customColor = UIColor(red: 255/255, green: 119/255, blue: 69/255, alpha: 1.0)
    let customBackground = UIColor(red: 201/255, green: 201/255, blue: 201/255, alpha: 1.0)

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        self.backgroundColor = customBackground
        self.timeLabel.isHidden = true
        let customFont = UIFont(name: "RawengulkRegular", size: 17)
        statusLabel.font = customFont
        nameLabel.font = customFont
        timeLabel.font = UIFont(name: "RawengulkRegular", size: 12)
        

        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.sensorImage.frame = CGRect(x:0.0,y:0.0,width:80.0,height:40.0)
        self.sensorImage.contentMode = .scaleAspectFit
//        self.contentView.backgroundColor = customBackground

    }
    
    func lastUpdate() {
        self.timeLabel.isHidden = false
        let currentTime = NSDate()
        print("CURRENT TIME IS: ", String(describing: currentTime))
        let label = "Last Updated: " + String(describing: currentTime)
        self.timeLabel.text = label
    }
    func hideLabels() {
        statusLabel.isHidden = true
        sensorImage.isHidden = true
        nameLabel.isHidden = true
        
    }
    
    func showLabels() {
        statusLabel.isHidden = false
        sensorImage.isHidden = false
        nameLabel.isHidden = false
        statusLabel.isHidden = false
    }
}
