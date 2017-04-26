//
//  Sensor.swift
//  3-20-client
//
//  Created by Mary Kate Nawalaniec on 4/25/17.
//  Copyright © 2017 Mary Kate Nawalaniec. All rights reserved.
//

import Foundation
//import Moscapsule



class Sensor {
    var name: String
    var status: String
    
//    //MARK: Variables for MQTT
//    var mqttClient: MQTTClient? = nil
//    var subscribed = false
    
    init(name: String) {
        self.name = name
        self.status = "Waiting"
//        beginMqtt(topic: name)
    }
    
//    func beginMqtt(topic: String) {
//        
//        
//        moscapsule_init()
//        //MARK: MQTT client configuration
//        
//        let mqttConfig = MQTTConfig(clientId: "MK_app_1", host: "senior-mqtt.esc.nd.edu", port: 1883, keepAlive: 60)
//        
//        
//        //MARK: mqtt Callbacks
//        
//        mqttConfig.onConnectCallback = { returnCode in
//            print("\(returnCode.description)")
//            print("Connect Callback")
//        }
//        mqttConfig.onMessageCallback = { mqttMessage in
//            
//            if mqttMessage.topic == topic {
//                NSLog("MATCHED TOPIC: payload=\(mqttMessage.payloadString)")
//                self.status = mqttMessage.payloadString!
//            }
//            
//            if mqttMessage.topic == "compToApp" {
//                if let dispString = mqttMessage.payloadString {
////                    DispatchQueue.main.sync(execute: {
////                        self.mqttTextView.text = dispString
////                    })
//                    NSLog(dispString)
//                    
//                }
//                
//                NSLog("MQTT Message received: payload=\(mqttMessage.payloadString)")
//            } else {
//                print("different topic")
//            }
//        }
//        
//        mqttConfig.onPublishCallback = { messageId in
//            print("............")
//            print("published (msg id=\(messageId)))")
//        }
//        
//        // create new Connection
//        mqttClient = MQTT.newConnection(mqttConfig)
//        
//        //subscribe and publish
//        mqttClient?.publishString("SD WASTE APP", topic: "app", qos: 1, retain: false)
//        
//        
//        mqttClient?.subscribe("compToApp", qos: 2) { mosqReturn, messageId in
//            self.subscribed = true
//            NSLog("subscribe completion: mosq_return=\(mosqReturn.rawValue) messageId=\(messageId)")
//        }
//        
//        mqttClient?.subscribe(topic, qos: 2) { mosqReturn, messageId in
//            self.subscribed = true
//            NSLog("subscribe completion: mosq_return=\(mosqReturn.rawValue) messageId=\(messageId)")
//        }
//        mqttClient?.awaitRequestCompletion()
//        
//    }
//    
    
}

 
