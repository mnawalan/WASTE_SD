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

class ViewController: UIViewController, UINavigationControllerDelegate {
    
    let vc = SensorTableViewController()
    
    //MARK: Outlets
    
   @IBOutlet weak var backgroundImageView: UIImageView!
    
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
//        self.navigationController?.isNavigationBarHidden = true
//        let image = UIImage(named: "doorBackground.jpg")
//        self.backgroundImageView = UIImageView(frame: CGRect.zero)
//        self.backgroundImageView.image = image?.alpha(0.5)
//        self.backgroundImageView.contentMode = .scaleAspectFill
//        
//        self.view.addSubview(backgroundImageView)
    
//        self.view.backgroundColor = UIColor(patternImage: image!)
//        self.view.contentMode = .scaleAspectFill
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = "Logout"
    }
    
    override func viewDidLayoutSubviews() {
//        self.backgroundImageView.frame = self.view.bounds
    }
    
    //MARK: UIButtonActions
    
    
    
    
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
            self.navigationItem.backBarButtonItem?.title = "Logout"
            self.navigationController?.navigationBar.backItem?.title = "Logout"
        }
    }
    
    
}



extension Error {
    var code: Int { return (self as NSError).code }
    var domain: String { return (self as NSError).domain }
}

extension UIImage{
    
    func alpha(_ value:CGFloat)->UIImage
    {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: CGPoint.zero, blendMode: .normal, alpha: value)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
        
    }
}


