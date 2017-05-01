//
//  NewSensorViewController.swift
//  3-20-client
//
//  Created by Mary Kate Nawalaniec on 3/29/17.
//  Copyright © 2017 Mary Kate Nawalaniec. All rights reserved.
//

import UIKit

class NewSensorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    let picker = UIImagePickerController()
    public var currentSensors = [Sensor]()
   
    
    
    @IBOutlet var newSensorView: UIView!
   
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var ImageButton: UIButton!
    
    @IBOutlet weak var SensorName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        SensorName.delegate = self
        let saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(SaveBarButton(_ :))) // action:#selector(Class.MethodName) for swift 3
        self.navigationItem.rightBarButtonItem  = saveButton
        //        self.navigationController?.navigationItem.backBarButtonItem?.title = "Cancel"
        //        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: nil)
        //        self.navigationItem.backBarButtonItem?.title = "Cancel"
        
        // Do any additional setup after loading the view.
        self.newSensorView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(textFieldShouldReturn)))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        //        self.navigationItem.backBarButtonItem?.title = "Cancel"
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        //        self.navigationItem.backBarButtonItem?.title = "Back"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "unwindToTableView" {
            if let newSensorName = SensorName.text {
                let sensorNameNoSpaces = newSensorName.trimmingCharacters(in: .whitespaces)
                if let controller = segue.destination as? SensorTableViewController {
                    controller.mySensors.append(Sensor(name:sensorNameNoSpaces, image: self.imageView.image!, status: nil, update: nil))
                    controller.saveSensors()
                    
                    if let newImage = self.imageView.image {

                        controller.myImages.append(newImage)
                    }
                    controller.subscribeToTopics()
                    controller.tableView.reloadData()
                }
                
                
            }
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        self.SensorName.resignFirstResponder()
        self.newSensorView.endEditing(true)
        return true
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    @IBAction func photoFromLibrary(_ sender: Any) {
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(picker, animated: true, completion: nil)
    }
    
    
    func SaveBarButton(_ sender: Any)  {
        if SensorName.text?.isEmpty ?? true {
            //            self.performSegue(withIdentifier: "saveSegue", sender: self)
            let alertController = UIAlertController(title: "Error", message:
                "Please enter a sensor name.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
        } else if currentSensors.contains(where: {$0.name == SensorName.text}) {
            let alertController = UIAlertController(title: "Sorry!", message:
                "That sensor name already exists.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
        } else {
            if let newSensorName = SensorName.text {
                performSegue(withIdentifier: "unwindToTableView", sender: self)
            }
            
        }
    }
    //MARK: - Delegates
    
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        NSLog("Image chosen")
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        imageView.contentMode = .scaleAspectFit //3
        imageView.image = chosenImage //4
        let img = chosenImage //Change to be from UIPicker
        let data = UIImagePNGRepresentation(img)
        UserDefaults.standard.set(data, forKey: "myImageKey")
        UserDefaults.standard.synchronize()
        
        dismiss(animated:true, completion: nil) //5
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}



