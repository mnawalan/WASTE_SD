//
//  SensorTableViewController.swift
//  3-20-client
//
//  Created by Mary Kate Nawalaniec on 4/5/17.
//  Copyright © 2017 Mary Kate Nawalaniec. All rights reserved.
//

import UIKit
import Moscapsule

class SensorTableViewController: UITableViewController {
    
    //MARK: Variables
    var mqttClient: MQTTClient? = nil
    var subscribed = false
    var message = "waiting"
    var previousLastPath = NSIndexPath()
    var messages = [String]()
    
    //public var mySensors = ["Door", "Window"]
    
    public var mySensors = [Sensor]()
    
    public var myImages = [UIImage(named: "Door"), UIImage(named: "Window")]
    
    @IBOutlet var sensorTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        sensorTable.delegate = self
        sensorTable.dataSource = self
        
        
        self.sensorTable.contentInset.top = 25
        self.sensorTable.scrollIndicatorInsets.top = 25
        
        moscapsule_init()
        //MARK: MQTT client configuration
        
        let mqttConfig = MQTTConfig(clientId: "MK_app_1", host: "senior-mqtt.esc.nd.edu", port: 1883, keepAlive: 60)
        
        
        //MARK: mqtt Callbacks
        
        mqttConfig.onConnectCallback = { returnCode in
            print("\(returnCode.description)")
            print("Connect Callback")
        }

        mqttConfig.onMessageCallback = { mqttMessage in
            
            let messageTopic = mqttMessage.topic
            
            if let index = self.mySensors.index(where: {$0.name == messageTopic}) {
                
                print("going to reload table")
                DispatchQueue.main.sync(execute: {
                    self.mySensors[index].status = mqttMessage.payloadString!
                    self.tableView.reloadData()
                })
            }
                           else if mqttMessage.topic == "compToApp" {
                if let dispString = mqttMessage.payloadString {
                    NSLog(dispString) }
                
                NSLog("MQTT Message received: payload=\(mqttMessage.payloadString)")
            } else {
                print("different topic", mqttMessage.payloadString)
            }
        }
        
        
        mqttConfig.onPublishCallback = { messageId in
            print("............")
            print("published (msg id=\(messageId)))")
        }
        
        // create new Connection
        mqttClient = MQTT.newConnection(mqttConfig)
        
        //subscribe and publish
        mqttClient?.publishString("SD WASTE APP", topic: "app", qos: 1, retain: false)
        
        
        mqttClient?.subscribe("compToApp", qos: 2) { mosqReturn, messageId in
            self.subscribed = true
            NSLog("subscribe completion: mosq_return=\(mosqReturn.rawValue) messageId=\(messageId)")
        }
        mqttClient?.awaitRequestCompletion()
        
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (mySensors.count + 1)
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "TransportCell", for: indexPath) as? UITableViewCell
        
        //        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? UITableViewCell
        if cell == nil {
            NSLog("NIL CELL PATH IS: ", String(indexPath.row))
            cell = UITableViewCell(style: .value1, reuseIdentifier: "TransportCell")
            cell?.detailTextLabel?.text = mySensors[indexPath.row].status
            print("nil cell")
        }
        
        
        
        // Configure the cell...
        // First figure out how many sections there are
        let lastSectionIndex = self.tableView!.numberOfSections - 1
        
        // Then grab the number of rows in the last section
        let lastRowIndex = self.tableView!.numberOfRows(inSection: lastSectionIndex) - 1
        
        // Now just construct the index path
        let pathToLastRow = NSIndexPath(row: lastRowIndex, section: lastSectionIndex)
        let newSensorRow = NSIndexPath(row: lastRowIndex - 1, section: lastSectionIndex)
        
        if indexPath == pathToLastRow as IndexPath {
            cell?.textLabel?.text = "Add New Sensor"
            cell?.textLabel?.textColor = UIColor.darkGray
            cell?.backgroundColor = UIColor.lightGray
            cell?.imageView?.image = UIImage(named: "#imageLiteral(resourceName: \"AddSensor\")")
            cell?.detailTextLabel?.isHidden = true
            
            
        }  else {
            cell?.detailTextLabel?.isHidden = false
            cell?.textLabel?.text = mySensors[indexPath.row].name
            cell?.imageView?.image = myImages[indexPath.row]
            
            cell?.detailTextLabel?.text = mySensors[indexPath.row].status
            cell?.backgroundColor = UIColor.white
            cell?.textLabel?.textColor = UIColor.black
            print("normal cell...element status is: ", mySensors[indexPath.row].status)
            
        }
        
        return cell!
        
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog("You selected cell number: \(indexPath.row)!")
        
        // First figure out how many sections there are
        let lastSectionIndex = self.tableView!.numberOfSections - 1
        
        // Then grab the number of rows in the last section
        let lastRowIndex = self.tableView!.numberOfRows(inSection: lastSectionIndex) - 1
        
        // Now just construct the index path
        let pathToLastRow = NSIndexPath(row: lastRowIndex, section: lastSectionIndex)
        
        
        if indexPath == pathToLastRow as IndexPath {
            if let controller = storyboard?.instantiateViewController(withIdentifier: "AddSensor") {
                self.navigationItem.backBarButtonItem?.title = "Cancel"
                self.navigationController!.pushViewController(controller, animated: false)
                
                
            }
        }
        
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            mySensors.remove(at: indexPath.row)
            myImages.remove(at: indexPath.row)
            self.tableView.reloadData()
            
            //NEED TO UNSUBSCRIBE FROM TOPIC
        }
    }
    
    
    @IBAction func unwindToTableView(segue: UIStoryboardSegue) {
        
    }
    
    func subscribeToTopics() {
        //MARK: subscribe to each topic
        
        for object in mySensors {
            mqttClient?.subscribe(object.name, qos: 2) { mosqReturn, messageId in
                self.subscribed = true
                NSLog("subscribe completion: mosq_return=\(mosqReturn.rawValue) messageId=\(messageId)")
            }
        }
    }
    
    
    
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        let newRed = CGFloat(red)/255
        let newGreen = CGFloat(green)/255
        let newBlue = CGFloat(blue)/255
        
        self.init(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
    }
}
