//
//  Sensor.swift
//  3-20-client
//
//  Created by Mary Kate Nawalaniec on 4/25/17.
//  Copyright © 2017 Mary Kate Nawalaniec. All rights reserved.
//

import Foundation
import UIKit
import os.log
//import Moscapsule



class Sensor: NSObject, NSCoding {
    //MARK: Properties
    var name: String
    var status: String?
    var image: UIImage?
    var update: String?
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("sensors")
    
    //MARK: Types
    
    struct PropertyKey {
        static let name = "name"
        static let status = "status"
        static let image = "image"
        static let update = "update"
    }
    
    //MARK: Initialization
    init(name: String, image: UIImage, status: String?, update: String?) {
        self.name = name
        if status == nil {
            self.status = "Waiting"
        } else {
            self.status = status
        }
        if update == nil {
            self.update = "Unknown"
        } else {
            self.update = update
        }
        self.image = image
        
    }
    
    //initialize without an image
    init(name: String) {
        self.name = name
        self.status = "Waiting"
        self.image = UIImage(named: "DefaultSensor")!
       self.update = "Unknown"
        
    }
    
    //MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(status, forKey: PropertyKey.status)
        aCoder.encode(image, forKey: PropertyKey.image)
        aCoder.encode(update, forKey: PropertyKey.update)
    }

    required convenience init?(coder aDecoder: NSCoder) {
        
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a Sensor object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let status = aDecoder.decodeObject(forKey: PropertyKey.status) as? String else {
            os_log("Unable to decode the status for a Sensor object.", log: OSLog.default, type: .debug)
            return nil
        }
        guard let update = aDecoder.decodeObject(forKey: PropertyKey.update) as? String else {
            os_log("Unable to decode the update time for a Sensor object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // Because photo is an optional property of Meal, just use conditional cast.
        let image = aDecoder.decodeObject(forKey: PropertyKey.image) as? UIImage
        
        // Must call designated initializer.
        self.init(name: name, image: image!, status: status, update: update)
        
    }
    
}


