//
//  ViewController.swift
//  3-20-client
//
//  Created by Mary Kate Nawalaniec on 3/20/17.
//  Copyright © 2017 Mary Kate Nawalaniec. All rights reserved.
//

import Foundation
import UIKit
import Moscapsule

class ViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var PublishButton: UIButton!
    
    @IBOutlet weak var DisconnectButton: UIButton!
    
    @IBOutlet weak var ReconnectButton: UIButton!
    
    @IBOutlet weak var SubscribeButton: UIButton!
    
    @IBOutlet weak var mqttTextView: UITextView!
    
    //MARK: Variables
    var mqttClient: MQTTClient? = nil
    var subscribed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        mqttTextView.text = "waiting..."
        moscapsule_init()
        
        //MARK: MQTT client configuration
        
        let mqttConfig = MQTTConfig(clientId: "MK_app_1", host: "senior-mqtt.esc.nd.edu", port: 1883, keepAlive: 60)
        
        
        //MARK: mqtt Callbacks
        
        mqttConfig.onConnectCallback = { returnCode in
            print("\(returnCode.description)")
            print("Connect Callback")
        }
        mqttConfig.onMessageCallback = { mqttMessage in
            //            print("in message callback")
            //
            //            print("MQTT Message received: payload=\(mqttMessage.payloadString!)")
            //            let receivedMessage = mqttMessage.payloadString!
            //
            //            print("from server msg = \(receivedMessage)")
            //
            //            let data = receivedMessage.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
            //            print("xxxxxxx = \(data)")
            if mqttMessage.topic == "compToApp" {
                if let dispString = mqttMessage.payloadString {
                    dispatch_sync(dispatch_get_main_queue(), {
                        self.mqttTextView.text = dispString
                        })
                    
                }

                NSLog("MQTT Message received: payload=\(mqttMessage.payloadString)")
            } else {
                print("different topic")
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
    
    //MARK: UIButtonActions
    
    
    @IBAction func Published(sender: AnyObject) {
        self.mqttClient?.publishString("publish button", topic: "app", qos: 1, retain: true) }
    
    @IBAction func ProceedToDisconnect(sender: AnyObject) {
        // disconnect
        mqttClient?.disconnect() }
    
    @IBAction func ProceedToReconnect(sender: AnyObject) {
        //reconnnect
        mqttClient?.reconnect()}
    
    @IBAction func ProceedToSubscribe(sender: AnyObject) {
        mqttClient?.subscribe("compToApp", qos: 2) }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}






