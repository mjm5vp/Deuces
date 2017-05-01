//
//  TableViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Mark Moeller on 1/16/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Parse
import GoogleMaps


class TableViewController: UITableViewController {
    
    var brain = PooBrain()
    var rowSelect = 0

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        brain.queryAndStore()
 //       brain.loopCoordinates()
 //       brain.convertMark
        brain.markerLocationList()
        
        self.tableView.reloadData()
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        

    }
    
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows

        if markBool == false {
            return brain.coordinates.count
            print("table cells count: \(brain.coordinates.count)")
        }
        else{
            return markDescriptions.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        
        print ("Index Path \(indexPath.row)")
        
        
        if markBool == false {
//        brain.pooImages[indexPath.row].getDataInBackground { (data, error) in
//            if let imageData = data {
//                if let pooImageIcon = UIImage(data: imageData){
//                    self.brain.pooImagesUI.append(pooImageIcon)
            cell.pooImage.image = UIImage(named: brain.pooNames[indexPath.row])
                    cell.descriptionLabel.text = self.brain.descriptions[indexPath.row]
                    cell.locationLabel.text = self.brain.locations[indexPath.row]
                    cell.dateLabel.text = self.brain.formatDate(dateInput: self.brain.dates[indexPath.row])
   //                 cell.dateLabel.text = String(describing: self.dates[indexPath.row])
            
                
        
    
        }else{
//            markPooImages[indexPath.row].getDataInBackground { (data, error) in
//                if let imageData = data {
//                    if let pooImageIcon = UIImage(data: imageData){
//                        markPooImagesUI.append(pooImageIcon)
                        print("pooIMages in loop: \(markPooImagesUI.count)")
                        cell.pooImage.image = UIImage(named: markPooNames[indexPath.row])
                        cell.descriptionLabel.text = markDescriptions[indexPath.row]
                        cell.locationLabel.text = markLocations[indexPath.row]
                        cell.dateLabel.text = self.brain.formatDate(dateInput: markDates[indexPath.row])
            
        }
                return cell
                }
    


        
 //       print (cell.descriptionLabel.text)
        
        

        // Configure the cell...


    
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
 //           brain.deletePoo(index: indexPath.row)
 //           brain.queryAndStore()
 //           removeObjectAtIndexPath(indexPath)
 //           tableView.reloadData()
            
            var objectID = ""
            
            if markBool == false {
         objectID = brain.objectIDs[indexPath.row]
            } else {
         objectID = markObjectIDs[indexPath.row]
            }
                
                
        let query = PFQuery(className: "PooMarker")
        query.whereKey("objectId", equalTo: objectID)
        
        
        query.findObjectsInBackground(block: { (objects, error) in
            if error != nil {
                print("THERE WAS AN ERROR DELETING THE OBJECT")
            }else{
                for object in objects!{
                    
                    object.deleteInBackground()
                    
                    
                }
//                self.tableView.beginUpdates()
                if markBool == false{
                    self.brain.coordinates.remove(at: indexPath.row)
                    self.brain.dates.remove(at: indexPath.row)
                    self.brain.descriptions.remove(at: indexPath.row)
                    self.brain.pooNames.remove(at: indexPath.row)
                    self.brain.locations.remove(at: indexPath.row)
                } else{
                    markDates.remove(at: indexPath.row)
                    markDescriptions.remove(at: indexPath.row)
                    markPooNames.remove(at: indexPath.row)
                    markLocations.remove(at: indexPath.row)
                }
                self.tableView.deleteRows(at: [indexPath], with: .fade)
 //               self.brain.queryAndStore()
                self.tableView.reloadData()
//                self.tableView.endUpdates()
                
            }
        })
            
            
    
            
 //           self.tableView.reloadData()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        
        rowSelect = indexPath.row
        currentPooString = brain.pooNames[indexPath.row]
        
        performSegue(withIdentifier: "cellToFlushSegue", sender: AnyObject.self)
    }
 

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    if segue.identifier == "cellToFlushSegue"{
        let destViewController: FlushViewController = segue.destination as! FlushViewController
        print("row select: \(rowSelect)")
        print("locations count: \(brain.locations.count)")
        destViewController.currentLocationFlush = brain.locations[rowSelect]
        destViewController.currentDescriptionFlush = brain.descriptions[rowSelect]
        destViewController.currentDateFlush = brain.dates[rowSelect]
        destViewController.currentObjectID = brain.objectIDs[rowSelect]
        destViewController.updateBool = true
        destViewController.currentButtonTitle = "Update"

        }
    }
    
    @IBAction func unwindToTableViewController(storyboard: UIStoryboardSegue){
        
    }
 

}
