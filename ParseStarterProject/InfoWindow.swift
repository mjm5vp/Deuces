//
//  InfoWindowController.swift
//  ParseStarterProject-Swift
//
//  Created by Mark Moeller on 1/26/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import Foundation
import UIKit

class InfoWindow: UIView {
    
    let mVC = MapViewController()
    
    
    @IBOutlet weak var locationLabel: UILabel!

    @IBOutlet weak var addButtonOutlet: UIButton!

    @IBAction func addButton(_ sender: UIButton) {
        
        print("addButton pressed")
 //       mVC.performSegue(withIdentifier: <#T##String#>, sender: <#T##Any?#>)
        
    }
    
    
    
}
