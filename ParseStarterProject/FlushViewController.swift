//
//  FlushViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Mark Moeller on 1/18/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation





class FlushViewController: UIViewController {
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var pooImageField: UIImageView!    
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var flushUpdateOutlet: UIButton!
    @IBOutlet weak var datePickerOutlet: UIDatePicker!
    
    @IBAction func datePickerAction(_ sender: Any) {
        let formatter = DateFormatter()
        formatter.dateFormat = "E MMM d, h:mm a, yyyy"
        dateTextField.text = formatter.string(from: datePickerOutlet.date)

    }
    
    @IBAction func dateTextFieldEditing(_ sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.dateAndTime
        
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(FlushViewController.datePickerValueChanged), for: UIControlEvents.valueChanged)
        
    }
    
    var yearsTillNow : [String] {
        var years = [String]()
        for i in (1970..<2018).reversed() {
            years.append("\(i)")
        }
        return years
    }
    
    func changeYear(){
        let yearPickerView: UIPickerView = UIPickerView()
        
 //       yearPickerView.dataSource = yearsTillNow
        
        dateTextField.inputView = yearPickerView
        
 //       yearPickerView.addTarget(self, action: #selector(FlushViewController.datePickerValueChanged), for: UIControlEvents.valueChanged)

    }
    

    
    func datePickerValueChanged(sender:UIDatePicker) {
        
        let dateformatter = DateFormatter()
        
        dateformatter.dateFormat = "E MMM d, h:mm a, yyyy"
        
        dateTextField.text = dateformatter.string(from: sender.date)
        
    }

    
    var currentLocationFlush = ""
    var currentDescriptionFlush = ""
    var currentDateFlush = NSDate()
    var currentButtonTitle = ""
    var currentObjectID = ""
    var updateBool = false
    
    
    var brain = PooBrain()
    
    

    
    @IBAction func flushButton(_ sender: UIButton) {
//        let changeMapViewController: MapViewController = MapViewController(nibName: nil, bundle: nil)
//        let mapView: GMSMapView = changeMapViewController.mapView
        
      if sender.currentTitle == "Flush"{
        self.performSegue(withIdentifier: "unwindToMenu", sender: self)
        }
        else if sender.currentTitle == "Update"{
        self.performSegue(withIdentifier: "unwindToTableViewController", sender: self)
        

        
        }
        
    }
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
 
        if segue.identifier == "unwindToMenu" {

            let destViewController: MapViewController = segue.destination as! MapViewController
            
            let mapView = destViewController.mapView
            let locationText = locationTextField.text
            let descriptionText = descriptionTextField.text
            let dateText = dateTextField.text
            let pooPlacer = destViewController.pooPlacer
            let toiletOutlet = destViewController.toiletOutlet

            
            destViewController.mapView.clear()
            brain.getLocation(mapView: mapView!)
            brain.savePoo(location: locationText!, description: descriptionText!, date: dateText!)
            brain.queryAndStore()
            brain.loopCoordinates()
            brain.placeMarkers(mapView: mapView!)
  //          brain.markerLocationList()
            
            pooPlacer?.isHidden = true
            toiletOutlet?.isHidden = true
            }else if segue.identifier == "unwindToTableViewController"{
                let destViewController: TableViewController = segue.destination as! TableViewController
                
                let locationText = locationTextField.text
                let descriptionText = descriptionTextField.text
                let dateText = dateTextField.text
                
                brain.updatePoo(location: locationText!, description: descriptionText!, date: dateText!, objectID: currentObjectID)
                
                
                
                
            }
            
            
        }

    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionTextField.frame.size.height = 60
        
        
        pooImageField.image = UIImage(named: currentPooString)
        locationTextField.text = currentLocationFlush
        descriptionTextField.text = currentDescriptionFlush
        flushUpdateOutlet.setTitle(currentButtonTitle, for: .normal)
        dateTextField.borderStyle = UITextBorderStyle.none
        dateTextField.backgroundColor = UIColor.green
        dateTextField.alpha = 00.8
        
        datePickerOutlet.isHidden = true
        toolbarStuff()
        
        let dateformatter = DateFormatter()
        
        dateformatter.dateFormat = "E MMM d, h:mm a, yyyy"
        
        if updateBool == true {
            dateTextField.text = dateformatter.string(from: currentDateFlush as Date)
        }else {
            let curDate = Date() as NSDate
            dateTextField.text = dateformatter.string(from: curDate as Date)
        }
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func toolbarStuff(){
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: self.view.frame.size.height/6, width: self.view.frame.size.width, height: 40.0))
        
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        
        toolBar.barStyle = UIBarStyle.blackTranslucent
        
        toolBar.tintColor = UIColor.white
        
        toolBar.backgroundColor = UIColor.black
        
        
        let todayBtn = UIBarButtonItem(title: "Today", style: UIBarButtonItemStyle.plain, target: self, action: #selector(FlushViewController.tappedToolBarBtn))
        
        let okBarBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(FlushViewController.donePressed))
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width / 3, height: self.view.frame.size.height))
        
        label.font = UIFont(name: "Helvetica", size: 12)
        
        label.backgroundColor = UIColor.clear
        
        label.textColor = UIColor.white
        
        label.text = "Select a poo date"
        
        label.textAlignment = NSTextAlignment.center
        
        let textBtn = UIBarButtonItem(customView: label)
        
        toolBar.setItems([todayBtn,flexSpace,textBtn,flexSpace,okBarBtn], animated: true)
        
        dateTextField.inputAccessoryView = toolBar
    }
    
    func donePressed(_ sender: UIBarButtonItem) {
        
        dateTextField.resignFirstResponder()
        
    }
    
    func tappedToolBarBtn(_ sender: UIBarButtonItem) {
        
        let dateformatter = DateFormatter()
        
        dateformatter.dateFormat = "E MMM d, h:mm a, yyyy"
        

        
        dateTextField.text = dateformatter.string(from: Date())
        
        
        dateTextField.resignFirstResponder()
        
  
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
