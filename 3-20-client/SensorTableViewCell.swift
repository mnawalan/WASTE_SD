//
//  SensorTableViewCell.swift
//  3-20-client
//
//  Created by Mary Kate Nawalaniec on 4/28/17.
//  Copyright © 2017 Mary Kate Nawalaniec. All rights reserved.
//

import UIKit

class SensorTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var sensorContent: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var sensorImage: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.timeLabel.isHidden = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        self.sensorImage.frame = CGRect(x:0.0,y:0.0,width:80.0,height:40.0)
//        self.sensorImage.contentMode = .scaleAspectFill
//    }
    
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
