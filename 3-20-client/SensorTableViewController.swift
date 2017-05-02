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
    var previousSelected : NSInteger = -1
    var deselect : Bool = false
    var connected : Bool = false
    var userinfo = UserDefaults.standard.bool(forKey: "connected")
    let mqttConfig = MQTTConfig(clientId: "MK_app_1", host: "senior-mqtt.esc.nd.edu", port: 1883, keepAlive: 60)
    
    
    
    
    @IBOutlet weak var sensorCell: UITableViewCell!
    
    
    public var mySensors = [Sensor]()
    
    
//    @IBOutlet var sensorTable: UITableView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        sensorTable.delegate = self
//        sensorTable.dataSource = self
//        
        
        if !(UserDefaults.standard.bool(forKey: "initialized")) {
            UserDefaults.standard.set(true, forKey: "initialized")
             moscapsule_init()
        }
        
       
        
        
        mqttConfig.onConnectCallback = { returnCode in
            if returnCode == ReturnCode.success {
                // something to do in case of successful connection
                print("\(returnCode.description)") //repeatedly called
                print("Connect Callback")
                self.connected = true
                UserDefaults.standard.set(true, forKey: "connected")
            }
            else {
                // error handling for connection failure
                print("FAILED!!!")
                self.connected = false
                UserDefaults.standard.set(false, forKey: "connected")
            }
            
        }
        
        mqttConfig.onMessageCallback = { mqttMessage in
            
            let messageTopic = mqttMessage.topic
            let delegate = UIApplication.shared.delegate as? AppDelegate
            
            if let index = self.mySensors.index(where: {$0.name == messageTopic}) {

                DispatchQueue.main.sync(execute: {
                    self.mySensors[index].status = mqttMessage.payloadString!
                    self.mySensors[index].update = self.getTime()
                    self.saveSensors()
//                    let path = NSIndexPath(row: index - 1, section: 0)
//                    self.tableView.reloadRows(at: [path as IndexPath], with: .none)

                    
                })
            }
            else if mqttMessage.topic == "compToApp" {
                if let dispString = mqttMessage.payloadString {
                    NSLog(dispString) }
                
                NSLog("MQTT Message received: payload=\(mqttMessage.payloadString)")
            } else {
                NSLog("different topic \(mqttMessage.payloadString)")
            }
            DispatchQueue.main.async {
                self.update()
            }

        }
        
        
        mqttConfig.onDisconnectCallback = { reasonCode in
            if reasonCode == ReasonCode.disconnect_Requested {
                self.connected = false
                UserDefaults.standard.set(false, forKey: "connected")
            } else {
                self.connected = true
                UserDefaults.standard.set(true, forKey: "connected")
            }
        }
        
        
        mqttConfig.onPublishCallback = { messageId in
            print("............")
            print("published (msg id=\(messageId)))")
        }
        
        // create new Connection only if not already connected
        if !(UserDefaults.standard.bool(forKey: "connected")) {
            mqttClient = MQTT.newConnection(mqttConfig)
        }

        
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
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //        mqttClient = MQTT.newConnection(mqttConfig)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        //        mqttClient?.disconnect()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0{
            return (mySensors.count)
        } else  {
            return 1
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "TransportCell", for: indexPath) as? SensorTableViewCell
        cell?.layoutSubviews()
        if cell == nil {
            NSLog("NIL CELL PATH IS: ", String(indexPath.row))
            cell = SensorTableViewCell(style: .value1, reuseIdentifier: "TransportCell")
            cell?.statusLabel?.text = mySensors[indexPath.row].status
        }
        
        // Configure the cell...
        
        if indexPath.section == 1 {
            cell?.statusLabel.isHidden = true
            cell?.timeLabel.isHidden = true
            cell?.nameLabel.text = "Add New Sensor"
            cell?.nameLabel.textColor = UIColor.darkGray
            cell?.backgroundColor = UIColor.lightGray
            
            
        }  else {
            cell?.showLabels()
            cell?.nameLabel?.text = mySensors[indexPath.row].name
            cell?.sensorImage?.image = mySensors[indexPath.row].image
            cell?.statusLabel?.text = mySensors[indexPath.row].status
            cell?.backgroundColor = UIColor.white
            cell?.nameLabel?.textColor = UIColor.black
            cell?.timeLabel.text = "Last Updated: \(mySensors[indexPath.row].update!)"
            
        }
        
        return cell!
        
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 1 {
            let controller = storyboard?.instantiateViewController(withIdentifier: "NewSensorViewController") as! NewSensorViewController
            controller.currentSensors = self.mySensors
            self.navigationItem.backBarButtonItem?.title = "Cancel"
            self.navigationController!.pushViewController(controller, animated: false)
            
        } else{
            let cell = tableView.cellForRow(at: indexPath) as! SensorTableViewCell
            cell.timeLabel.isHidden = false
            
            selectedIndex = indexPath.row
            if selectedIndex == previousSelected {
                previousSelected = -1
                deselect = true
            } else {
                previousSelected = selectedIndex
                deselect = false
            }
            
        }
        tableView.beginUpdates()
        tableView.endUpdates()
        
    }
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath as IndexPath) as! SensorTableViewCell
        cell.timeLabel.isHidden = true
    }
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if indexPath.row == selectedIndex {
                selectedIndex = -1
                if deselect {
                    deselect = false
                    let selectedCell = tableView.indexPathForSelectedRow
                    let cell = tableView.cellForRow(at: selectedCell!) as! SensorTableViewCell
                    cell.timeLabel.isHidden = true
                    return 65
                } else {
                    return 95
                }
            } else {
                return 65
            }
        } else {
            return 65
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
    
    func getTime() -> String? {
        let todaysDate:NSDate = NSDate()
        let dateFormatter:DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd hh:mm a"
        let DateInFormat:String = dateFormatter.string(from: todaysDate as Date)
        return DateInFormat
    }
    
    func initializeMQTT() {
        if (!AppDelegate.initialized) {
            moscapsule_init()
            AppDelegate.initialized = true;
        }
    }
    func update() {
         self.tableView.reloadData()
    }

    
    
    
}

public extension UITableView {
    
    public func deselectSelectedRowAnimated(animated: Bool) {
        if let indexPath = indexPathForSelectedRow {
            deselectRow(at: indexPath, animated: animated)
        }
    }
    
}


