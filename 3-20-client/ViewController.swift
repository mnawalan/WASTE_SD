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
import LocalAuthentication

class ViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var PublishButton: UIButton!
    
    @IBOutlet weak var DisconnectButton: UIButton!
    
    @IBOutlet weak var ReconnectButton: UIButton!
    
    @IBOutlet weak var SubscribeButton: UIButton!
    
    @IBOutlet weak var mqttTextView: UITextView!
    
    @IBOutlet weak var addSensorButton: UIButton!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBAction func loginButtonClicked(_ sender: Any) {
        
        // 1. Create a authentication context
        let authenticationContext = LAContext()
        
        
        var error:NSError?
        
        // 2. Check if the device has a fingerprint sensor
        // If not, show the user an alert view and bail out!
        guard authenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            
            showAlertViewIfNoBiometricSensorHasBeenDetected()
            return
            
        }
        // 3. Check the fingerprint
        authenticationContext.evaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics,
            localizedReason: "Login to View System",
            reply: { [unowned self] (success, error) -> Void in
                
                if( success ) {
                    
                    // Fingerprint recognized
                    // Go to view controller
                    self.navigateToAuthenticatedViewController()
                    
                }else {
                    
                    // Check if there is an error
                    if let error = error {

                        
                        let message = self.errorMessageForLAErrorCode(errorCode: error.code)
                        self.showAlertViewAfterEvaluatingPolicyWithMessage(message: message)
                        
                    }
                    
                }
                
        })

    }

    func showAlertViewIfNoBiometricSensorHasBeenDetected(){
        
        showAlertWithTitle(title: "Error", message: "This device does not have a TouchID sensor.")
        
    }
    
    func showAlertWithTitle( title:String, message:String ) {
        
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertVC.addAction(okAction)
        
        DispatchQueue.main.async { () -> Void in
            
            self.present(alertVC, animated: true, completion: nil)
            
        }
        
    }
    
    func showAlertViewAfterEvaluatingPolicyWithMessage( message:String ){
        
        showAlertWithTitle(title: "Error", message: message)
        
    }


    func navigateToAuthenticatedViewController(){
        print("NAVIGATING")
        
        if let loggedInVC = storyboard?.instantiateViewController(withIdentifier: "SensorViewController") {
          
            DispatchQueue.main.async { () -> Void in
                
                self.navigationController?.pushViewController(loggedInVC, animated: true)
                
            }
            
        }
        
    }
    

    func errorMessageForLAErrorCode( errorCode:Int ) -> String{
        
        var message = ""
        
        switch errorCode {
            
        case LAError.appCancel.rawValue:
            message = "Authentication was cancelled by application"
            
        case LAError.authenticationFailed.rawValue:
            message = "The user failed to provide valid credentials"
            
        case LAError.invalidContext.rawValue:
            message = "The context is invalid"
            
        case LAError.passcodeNotSet.rawValue:
            message = "Passcode is not set on the device"
            
        case LAError.systemCancel.rawValue:
            message = "Authentication was cancelled by the system"
            
        case LAError.touchIDLockout.rawValue:
            message = "Too many failed attempts."
            
        case LAError.touchIDNotAvailable.rawValue:
            message = "TouchID is not available on the device"
            
        case LAError.userCancel.rawValue:
            message = "The user did cancel"
            
        case LAError.userFallback.rawValue:
            message = "The user chose to use the fallback"
            
        default:
            message = "Did not find error code on LAError object"
            
        }
        
        return message
        
    }

        //MARK: Variables
//    var mqttClient: MQTTClient? = nil
//    var subscribed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        // Do any additional setup after loading the view, typically from a nib.
//        
//        mqttTextView.text = "waiting..."
//        moscapsule_init()
//        
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
//            if mqttMessage.topic == "compToApp" {
//                if let dispString = mqttMessage.payloadString {
//                    DispatchQueue.main.sync(execute: {
//                        self.mqttTextView.text = dispString
//                    })
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
//        mqttClient?.awaitRequestCompletion()
        
        
    }
    
    //MARK: UIButtonActions
    
    
    @IBAction func Published(_ sender: AnyObject) {
//        self.mqttClient?.publishString("publish button", topic: "app", qos: 1, retain: true) 
    }
    
    @IBAction func ProceedToDisconnect(_ sender: AnyObject) {
        // disconnect
//        mqttClient?.disconnect()
    }
    
    @IBAction func ProceedToReconnect(_ sender: AnyObject) {
        //reconnnect
//        mqttClient?.reconnect()
    }
    
    @IBAction func ProceedToSubscribe(_ sender: AnyObject) {
//        mqttClient?.subscribe("compToApp", qos: 2) 
    }

    
    @IBAction func unwindToMain(segue: UIStoryboardSegue) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sensors" {
            if let controller = storyboard?.instantiateViewController(withIdentifier: "SensorViewController") {
                self.navigationController!.pushViewController(controller, animated: false)}
        }
    }
    
    
}



extension Error {
    var code: Int { return (self as NSError).code }
    var domain: String { return (self as NSError).domain }
}


