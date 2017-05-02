//
//  NewSensorViewController.swift
//  3-20-client
//
//  Created by Mary Kate Nawalaniec on 3/29/17.
//  Copyright © 2017 Mary Kate Nawalaniec. All rights reserved.
//

import UIKit

class NewSensorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    
    @IBOutlet weak var imageScrollView: UIScrollView!
    //    @IBOutlet weak var imageTableView: UITableView!
    
    let picker = UIImagePickerController()
    public var currentSensors = [Sensor]()
    let presetIcons = [UIImage(named:"Door"), UIImage(named: "Window"), UIImage(named: "DefaultSensor"), UIImage(named: "GarageDoor"), UIImage(named: "Motion")]
    fileprivate let reuseID = "iconCell"
    fileprivate let previousCell = -1
    var imageLocations = [CGFloat]()
    //    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    
    @IBOutlet var newSensorView: UIView!
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var ImageButton: UIButton!
    
    @IBOutlet weak var SensorName: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        SensorName.delegate = self
        self.buildStackView()
        //        tap.delegate = self
        
        //        imageTableView.delegate = self
        //        imageTableView.dataSource = self
        //        imageTableView.setContentOffset(CGPoint.zero, animated: true)
        
        
        
        
        let saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(SaveBarButton(_ :))) // action:#selector(Class.MethodName) for swift 3
        self.navigationItem.rightBarButtonItem  = saveButton
        
        
        // Do any additional setup after loading the view.
        //        self.newSensorView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(textFieldShouldReturn)))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    //    // MARK: - Table view data source
    //
    //
    //     func numberOfSections(in tableView: UITableView) -> Int {
    //        // #warning Incomplete implementation, return the number of sections
    //        return 1
    //    }
    //
    //     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //        // #warning Incomplete implementation, return the number of rows
    //        return presetIcons.count
    //    }
    //
    //    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //        let cell = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath) as? IconTableViewCell
    //        cell?.imageView?.image = presetIcons[indexPath.row]
    //        return cell!
    //    }
    //
    //    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //        print("SELECTED: ", String(indexPath.row))
    //        let cell = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath) as? IconTableViewCell
    //        let selected = cell!.cellSelected
    //        print("starting selected state: ", selected.description)
    //        if selected {
    //            tableView.deselectRow(at: indexPath, animated: false)
    //            cell?.cellSelected = false
    //        } else {
    //            cell?.checkmarkImageView?.isHidden = false
    //            cell?.cellSelected = true
    //        }
    //    }
    //
    //    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    //        print("DESELECTED: ", String(indexPath.row))
    //        let cell = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath) as? IconTableViewCell
    //        cell?.checkmarkImageView?.isHidden = true
    //    }
    //
    
    
    
    
    
    
    
    
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
            if SensorName.text != nil {
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
    func storeImage(_ gesture: UITapGestureRecognizer) {
        print("MAMA WE MADE IT")
        let touchLocation = gesture.location(in: gesture.view)
        
        var index = -1
        let xCoord = touchLocation.x
        if (xCoord > 0) && (xCoord < imageLocations[0]) {
            index = 0
        } else if (xCoord > imageLocations[0]) && (xCoord < imageLocations[1]) {
            index = 1
        }else if (xCoord > imageLocations[1]) && (xCoord < imageLocations[2]) {
            index = 2
        } else if (xCoord > imageLocations[2]) && (xCoord < imageLocations[3]) {
            index = 3
        } else if (xCoord > imageLocations[3]) {
            index = 4
        }
        
        if index != -1 {
            self.imageView.image = presetIcons[index]
        }
        
        
    }
    
    func buildStackView() {
        
        let imageWidth:CGFloat = 66
        let imageHeight:CGFloat = 66
        var xPosition:CGFloat = 0
        var scrollViewSize:CGFloat=0
        var tags:Int = 0
        
        
        
        for image in presetIcons {
            let myImage:UIImage = image!
            let myImageView:UIImageView = UIImageView()
            let tap = UITapGestureRecognizer(target: self, action: #selector(NewSensorViewController.storeImage(_:)))
            
            tap.cancelsTouchesInView = false
            
            
            myImageView.image = myImage
            
            myImageView.frame.size.width = imageWidth
            myImageView.frame.size.height = imageHeight
            myImageView.frame.origin.x = xPosition
            myImageView.frame.origin.y = 10
            
            myImageView.addGestureRecognizer(tap)
            
            self.imageScrollView.addGestureRecognizer(tap)
            
            imageScrollView.addSubview(myImageView)
            xPosition += imageWidth + 10.0
            scrollViewSize += imageWidth + 10.0
            imageLocations.append(xPosition)
            tags += 1
        }
        imageScrollView.contentSize = CGSize(width: scrollViewSize, height: imageHeight)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    
}







////
////  NewSensorViewController.swift
////  3-20-client
////
////  Created by Mary Kate Nawalaniec on 3/29/17.
////  Copyright © 2017 Mary Kate Nawalaniec. All rights reserved.
////
//
//import UIKit
//
//class NewSensorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
//    
//    @IBOutlet weak var imageTableView: UITableView!
//    
//    let picker = UIImagePickerController()
//    public var currentSensors = [Sensor]()
//    let presetIcons = [UIImage(named:"Door"), UIImage(named: "Window"), UIImage(named: "DefaultSensor"), UIImage(named: "GarageDoor"), UIImage(named: "Motion")]
//    fileprivate let reuseID = "iconCell"
//    fileprivate let previousCell = -1
//    
////    @IBOutlet weak var imageCollectionView: UICollectionView!
//    
//    
//    @IBOutlet var newSensorView: UIView!
//    
//    
//    @IBOutlet weak var imageView: UIImageView!
//    
//    @IBOutlet weak var ImageButton: UIButton!
//    
//    @IBOutlet weak var SensorName: UITextField!
//    
//
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        picker.delegate = self
//        SensorName.delegate = self
//        
//        imageTableView.delegate = self
//        imageTableView.dataSource = self
//        imageTableView.setContentOffset(CGPoint.zero, animated: true)
//        
//
//        
//        
//        let saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(SaveBarButton(_ :))) // action:#selector(Class.MethodName) for swift 3
//        self.navigationItem.rightBarButtonItem  = saveButton
//        //        self.navigationController?.navigationItem.backBarButtonItem?.title = "Cancel"
//        //        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: nil)
//        //        self.navigationItem.backBarButtonItem?.title = "Cancel"
//        
//        // Do any additional setup after loading the view.
////        self.newSensorView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(textFieldShouldReturn)))
//    }
//    
//    override func viewDidAppear(_ animated: Bool) {
//
//    }
//    // MARK: - Table view data source
//
//    
//     func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }
//    
//     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return presetIcons.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath) as? IconTableViewCell
//        cell?.imageView?.image = presetIcons[indexPath.row]
//        return cell!
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("SELECTED: ", String(indexPath.row))
//        let cell = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath) as? IconTableViewCell
//        let selected = cell!.cellSelected
//        print("starting selected state: ", selected.description)
//        if selected {
//            tableView.deselectRow(at: indexPath, animated: false)
//            cell?.cellSelected = false
//        } else {
//            cell?.checkmarkImageView?.isHidden = false
//            cell?.cellSelected = true
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        print("DESELECTED: ", String(indexPath.row))
//        let cell = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath) as? IconTableViewCell
//        cell?.checkmarkImageView?.isHidden = true
//    }
//    
//    
//    
//    
//    
//    
//    
//    
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    override func viewWillAppear(_ animated: Bool) {
//        //        self.navigationItem.backBarButtonItem?.title = "Cancel"
//    }
//    
//    override func viewDidDisappear(_ animated: Bool) {
//        //        self.navigationItem.backBarButtonItem?.title = "Back"
//    }
//    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        
//        if segue.identifier == "unwindToTableView" {
//            if let newSensorName = SensorName.text {
//                let sensorNameNoSpaces = newSensorName.trimmingCharacters(in: .whitespaces)
//                if let controller = segue.destination as? SensorTableViewController {
//                    controller.mySensors.append(Sensor(name:sensorNameNoSpaces, image: self.imageView.image!, status: nil, update: nil))
//                    controller.saveSensors()
//  
//                    controller.subscribeToTopics()
//                    controller.tableView.reloadData()
//                }
//                
//                
//            }
//        }
//    }
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        //        self.SensorName.resignFirstResponder()
//        self.newSensorView.endEditing(true)
//        return true
//    }
//    
//    
//    /*
//     // MARK: - Navigation
//     
//     // In a storyboard-based application, you will often want to do a little preparation before navigation
//     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//     // Get the new view controller using segue.destinationViewController.
//     // Pass the selected object to the new view controller.
//     }
//     */
//    
//    
//    @IBAction func photoFromLibrary(_ sender: Any) {
//        picker.allowsEditing = false
//        picker.sourceType = .photoLibrary
//        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
//        present(picker, animated: true, completion: nil)
//    }
//    
//    
//    func SaveBarButton(_ sender: Any)  {
//        if SensorName.text?.isEmpty ?? true {
//            //            self.performSegue(withIdentifier: "saveSegue", sender: self)
//            let alertController = UIAlertController(title: "Error", message:
//                "Please enter a sensor name.", preferredStyle: .alert)
//            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default,handler: nil))
//            self.present(alertController, animated: true, completion: nil)
//        } else if currentSensors.contains(where: {$0.name == SensorName.text}) {
//            let alertController = UIAlertController(title: "Sorry!", message:
//                "That sensor name already exists.", preferredStyle: .alert)
//            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default,handler: nil))
//            self.present(alertController, animated: true, completion: nil)
//        } else {
//            if let newSensorName = SensorName.text {
//                performSegue(withIdentifier: "unwindToTableView", sender: self)
//            }
//            
//        }
//    }
//    //MARK: - Delegates
//    
//    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
//    {
//        NSLog("Image chosen")
//        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
//        imageView.contentMode = .scaleAspectFit //3
//        imageView.image = chosenImage //4
//        let img = chosenImage //Change to be from UIPicker
//        let data = UIImagePNGRepresentation(img)
//        UserDefaults.standard.set(data, forKey: "myImageKey")
//        UserDefaults.standard.synchronize()
//        
//        dismiss(animated:true, completion: nil) //5
//    }
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        dismiss(animated: true, completion: nil)
//    }
//}
//
//
//
//
//
