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
    @IBOutlet weak var PublishButton: UIButton!
    
    @IBOutlet weak var DisconnectButton: UIButton!
    
    var mqttClient: MQTTClient? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Note that you must initialize framework only once after launch application
        // in case that it uses SSL/TLS functions.
        moscapsule_init()
        
//        let mqttConfig = MQTTConfig(clientId: "server_cert_test", host: "test.mosquitto.org", port: 8883, keepAlive: 60)
//  
//        let bundlePath = NSBundle.
//        
//        let bundlePath = NSBundle(forClass: self.dynamicType).bundlePath.stringByAppendingPathComponent("cert.bundle")
//        let certFile = bundlePath.stringByAppendingPathComponent("mosquitto.org.crt")
//        
//        mqttConfig.mqttServerCert = MQTTServerCert(cafile: certFile, capath: nil)
//        
//        let mqttClient = MQTT.newConnection(mqttConfig)
        
        
        
        //set MQTT client configuration
        
        let mqttConfig = MQTTConfig(clientId: "MK_app_1", host: "senior-mqtt.esc.nd.edu", port: 1883, keepAlive: 60)
        
        // create new Connection
        mqttClient = MQTT.newConnection(mqttConfig)
        
        //subscribe and publish

        
        
        mqttConfig.onConnectCallback = { returnCode in
            print("\(returnCode.description)")
            print("Connect Callback")
        }
        mqttConfig.onMessageCallback = { mqttMessage in
            
            print("MQTT Message received: payload=\(mqttMessage.payloadString)")
            let receivedMessage = mqttMessage.payloadString!
            print("from server msg = \(receivedMessage)")
            
            let data = receivedMessage.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
            print("xxxxxxx = \(data)")
        }
        
        mqttConfig.onPublishCallback = { messageId in
            print("............")
            print("published (msg id=\(messageId)))")
        }
        
        mqttClient?.publishString("hard coded message", topic: "Window1", qos: 1, retain: false)
        mqttClient?.subscribe("Window1", qos: 1)
        print("subscribed")

  
    }
    
    
    @IBAction func Published(sender: AnyObject) {
        // publish the user unique ID when user click the button
        
        self.mqttClient?.publishString("messageToPublish", topic: "Window1", qos: 1, retain: true)
        
    }
    @IBAction func ProceedToDisconnect(sender: AnyObject) {
        // disconnect
        mqttClient?.disconnect()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}






