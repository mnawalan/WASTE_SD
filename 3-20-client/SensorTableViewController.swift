//
//  SensorTableViewController.swift
//  3-20-client
//
//  Created by Mary Kate Nawalaniec on 4/5/17.
//  Copyright © 2017 Mary Kate Nawalaniec. All rights reserved.
//

import UIKit
import Moscapsule
import os.log

class SensorTableViewController: UITableViewController {
    
    //MARK: Variables
    var mqttClient: MQTTClient? = nil
    var subscribed = false
    var message = "waiting"
    var previousLastPath = NSIndexPath()
    var messages = [String]()
    var selectedIndex : NSInteger = -1 //to store index of selected cell
    
    
    @IBOutlet weak var sensorCell: UITableViewCell!
    
    
    public var mySensors = [Sensor]()
    
    public var myImages = [UIImage(named: "Door"), UIImage(named: "Window")]
    
    @IBOutlet var sensorTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userinfo = UserDefaults.standard.bool(forKey: "firstlaunch1.0")
        print("USERINFO: ", userinfo.description)
        sensorTable.delegate = self
        sensorTable.dataSource = self
        
        
        if(!UserDefaults.standard.bool(forKey: "firstlaunch1.0")){
            moscapsule_init()
            print("Is a first launch")
            UserDefaults.standard.set(true, forKey: "firstlaunch1.0")
            UserDefaults.standard.synchronize();
        }
        
        //MARK: MQTT client configuration
        
        let mqttConfig = MQTTConfig(clientId: "MK_app_1", host: "senior-mqtt.esc.nd.edu", port: 1883, keepAlive: 60)
        
        
        //MARK: mqtt Callbacks
        
        mqttConfig.onConnectCallback = { returnCode in
            print("\(returnCode.description)") //repeatedly called
            print("Connect Callback")
        }
        
        mqttConfig.onMessageCallback = { mqttMessage in
            
            print("yo i got it tho")
            
            let messageTopic = mqttMessage.topic
            
            if let index = self.mySensors.index(where: {$0.name == messageTopic}) {
                
                print("going to reload table")
                DispatchQueue.main.sync(execute: {
                    self.mySensors[index].status = mqttMessage.payloadString!
                    self.saveSensors()
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
        
        if let savedSensors = loadSensors() {
            mySensors += savedSensors
            subscribeToTopics()
        }
        
        mqttClient?.subscribe("compToApp", qos: 2) { mosqReturn, messageId in
            self.subscribed = true
            NSLog("subscribe completion: mosq_return=\(mosqReturn.rawValue) messageId=\(messageId)")
        }
        mqttClient?.awaitRequestCompletion()
        
        
        //        self.sensorTable.contentInset.top = 10
        //        self.sensorTable.scrollIndicatorInsets.top = 10
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //        if self.isBeingPresented || self.isMovingToParentViewController {
        //            // Perform an action that will only be done once
        //
        //
        //        }
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
        var cell = tableView.dequeueReusableCell(withIdentifier: "TransportCell", for: indexPath) as? SensorTableViewCell
        
        //        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? UITableViewCell
        if cell == nil {
            NSLog("NIL CELL PATH IS: ", String(indexPath.row))
            cell = SensorTableViewCell(style: .value1, reuseIdentifier: "TransportCell")
            cell?.statusLabel?.text = mySensors[indexPath.row].status
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
            print("last cell")
            //            var addCell = tableView.dequeueReusableCell(withIdentifier: "TransportCell", for: indexPath) as? UITableViewCell
            //            addCell?.textLabel?.text = "Add New Sensor"
            //            addCell?.textLabel?.textColor = UIColor.darkGray
            //            addCell?.backgroundColor = UIColor.lightGray
            //            addCell?.imageView?.image = UIImage(named: "#imageLiteral(resourceName: \"AddSensor\")")
            //            addCell?.detailTextLabel?.isHidden = true
            //            cell?.hideLabels()
            cell?.statusLabel.isHidden = true
            cell?.timeLabel.isHidden = true
            cell?.nameLabel.text = "Add New Sensor"
            cell?.nameLabel.textColor = UIColor.darkGray
            cell?.sensorImage?.image = UIImage(named: "AddSensor")
            cell?.backgroundColor = UIColor.lightGray
            
            
        }  else {
            cell?.showLabels()
            cell?.nameLabel?.text = mySensors[indexPath.row].name
            cell?.sensorImage?.image = mySensors[indexPath.row].image
            cell?.sensorImage?.contentMode = .scaleAspectFit
            let newImage = cell?.sensorImage
            
            
            cell?.statusLabel?.text = mySensors[indexPath.row].status
            cell?.backgroundColor = UIColor.white
            cell?.nameLabel?.textColor = UIColor.black
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
            let controller = storyboard?.instantiateViewController(withIdentifier: "NewSensorViewController") as! NewSensorViewController
            controller.currentSensors = self.mySensors
            self.navigationItem.backBarButtonItem?.title = "Cancel"
            self.navigationController!.pushViewController(controller, animated: false)
            
        } else if indexPath.row == selectedIndex{
            selectedIndex = -1
        }else{
            selectedIndex = indexPath.row
        }
        tableView.reloadData()
        
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let numberOfSensors = mySensors.count
        if (indexPath.row == numberOfSensors - 1) {
            return 85
        } else {
            if indexPath.row == selectedIndex {
                selectedIndex = -1
                return 87
            } else {
                return 64
            }
        }
    }
    
    
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editAction = UITableViewRowAction(style: .default, title: "Edit", handler: { (action, indexPath) in
            let alert = UIAlertController(title: "Edit Sensor Name", message: "Physical device must be reconfigured, too.", preferredStyle: .alert)
            alert.addTextField(configurationHandler: { (textField) in
                textField.text = self.mySensors[indexPath.row].name
            })
            alert.addAction(UIAlertAction(title: "Update", style: .default, handler: { (updateAction) in
                self.mySensors[indexPath.row].name = alert.textFields!.first!.text!
                self.saveSensors()
                self.tableView.reloadRows(at: [indexPath], with: .fade)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: false)
        })
        
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: { (action, indexPath) in
            let confirm = UIAlertController(title: "", message: "Are you sure you want to delete this sensor?", preferredStyle: .alert)
            confirm.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (updateAction) in
                // handle delete (by removing the data from your array and updating the tableview)
                self.mqttClient?.unsubscribe(self.mySensors[indexPath.row].name)
                self.mySensors.remove(at: indexPath.row)
                //                self.myImages.remove(at: indexPath.row)
                self.saveSensors()
                self.tableView.reloadData()
            }))
            confirm.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
            self.present(confirm, animated: false)
            
        })
        
        editAction.backgroundColor = UIColor.green
        
        return [deleteAction, editAction]
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
    func saveSensors() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(mySensors, toFile: Sensor.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Sensors successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save sensors...", log: OSLog.default, type: .error)
        }
    }
    
    func loadSensors() -> [Sensor]?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Sensor.ArchiveURL.path) as? [Sensor]
    }
}


