//
//  NewSensorViewController.swift
//  3-20-client
//
//  Created by Mary Kate Nawalaniec on 3/29/17.
//  Copyright © 2017 Mary Kate Nawalaniec. All rights reserved.
//

import UIKit

class NewSensorViewController: UIViewController {
    
    @IBOutlet weak var ExitButton: UIBarButtonItem!
    
    @IBOutlet weak var SaveButton: UIBarButtonItem!
    
    @IBOutlet weak var ImageButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "saveSegue"{
            if let vc = segue.destination as? ViewController {
                vc.mqttTextView.text = "save successful"
                //vc.colorString = colorLabel.text! }
            }
        }
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */

    @IBAction func CancelButton(_ sender: Any) {
            self.performSegue(withIdentifier: "cancelSegue", sender: self)
    }
    
    @IBAction func SaveButton(_ sender: Any) {
        self.performSegue(withIdentifier: "saveSegue", sender: self)
        
    }
    
    @IBAction func chooseImage(_ sender: Any) {
        
    }
}



