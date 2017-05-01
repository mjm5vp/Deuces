//
//  SelectorViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Mark Moeller on 1/5/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit

var currentPoo = UIImage(named: "basic.png")
var currentPooString = ""


class SelectorViewController: UIViewController {
    

    var brain = PooBrain()
    
    

    @IBAction func cancelButton(_ sender: AnyObject) {
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func pooSelectedButton(_ sender: UIButton) {
        /*
        let view2 = self.storyboard?.instantiateViewController(withIdentifier: "view2") as! MapViewController;
        self.navigationController?.pushViewController(view2, animated: true);
        
        view2.pooPlacer.isHidden = false
        view2.toiletImage.isHidden = false
        view2.pooPlacer.image = sender.image;
        */
        
        
 //       currentPoo = sender.currentImage
        currentPooString = sender.restorationIdentifier!
        
        
     //   mapBackController.pooPlacer.image = currentPoo
      //  mapBackController.pooPlacer.isHidden = false
        print("addBool = \(addBool)")
        
        if addBool == true {
            performSegue(withIdentifier: "toFlush", sender: self)
        }else {
            performSegue(withIdentifier: "unwindToMenu", sender: self)
        }
    //    navigationController?.popViewController(animated: true)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
    
        if segue.identifier == "unwindToMenu" {
            let destViewController: MapViewController = segue.destination as! MapViewController
            
            destViewController.pooPlacer.image = UIImage(named: currentPooString)
            destViewController.pooPlacer.isHidden = false
            destViewController.toiletOutlet.isHidden = false
        }else if segue.identifier == "toFlush" {
            let dVCflush: FlushViewController = segue.destination as! FlushViewController
            
            dVCflush.currentButtonTitle = "Flush"
            dVCflush.updateBool = false
            
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
