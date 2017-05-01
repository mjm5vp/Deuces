/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
import Parse
import GoogleMaps
import CoreLocation
import FBSDKLoginKit


class ViewController: UIViewController{
    
    var brain = PooBrain()
//    var mVC = MapViewController()
    @IBOutlet weak var viewMapButtonOutlet: UIButton!
    @IBOutlet weak var viewLogButtonOutlet: UIButton!
    @IBOutlet weak var settingsButtonOutlet: UIButton!
    @IBOutlet weak var viewStatsButtonOutlet: UIButton!
    

    @IBAction func viewMapButton(_ sender: UIButton) {
    
        
    }
    
    @IBAction func viewStatsButton(_ sender: UIButton) {
    }
    
    @IBAction func viewSettingsButton(_ sender: UIButton) {
        performSegue(withIdentifier: "toSettingsSegue", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var buttonHeight: Int = 30
        
        // Do any additional setup after loading the view, typically from a nib.
        customizeButton(button: viewMapButtonOutlet)
        customizeButton(button: viewLogButtonOutlet)
        customizeButton(button: viewStatsButtonOutlet)
        customizeButton(button: settingsButtonOutlet)
        
        
        viewMapButtonOutlet.frame = CGRect(x: 0, y: 380, width: Int(self.view.bounds.width), height: buttonHeight)
        viewLogButtonOutlet.frame = CGRect(x: 0, y: 430, width: Int(self.view.bounds.width), height: buttonHeight)
        viewStatsButtonOutlet.frame = CGRect(x: 0, y: 480, width: Int(self.view.bounds.width), height: buttonHeight)
        settingsButtonOutlet.frame = CGRect(x: 0, y: 530, width: Int(self.view.bounds.width), height: buttonHeight)
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 50))
        label.center = CGPoint(x: self.view.center.x, y: 200)
        label.textAlignment = .center
        label.text = "Hoos Going Poo"
        label.font = UIFont(name: "American Typewriter", size: 50)
        label.textColor = UIColor.orange
        self.view.addSubview(label)
        
    }
    
    func customizeButton(button: UIButton!) {
        button.setBackgroundImage(nil, for: .normal)
        button.backgroundColor = UIColor.cyan
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont(name: "American Typewriter", size: 20)
        button.alpha = 0.5
    }
    
    
 

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        brain.queryAndStore()
        if segue.identifier == "logSeg" {
            markBool = false
        }
    }
    


}
