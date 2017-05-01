//
//  PooBrain.swift
//  ParseStarterProject-Swift
//
//  Created by Mark Moeller on 1/18/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import Foundation
import CoreLocation
import GoogleMaps
import Parse

var addBool = false
var markBool = false
var tapMarker = GMSMarker()

var markPooImages = [PFFile]()
var markPooImagesUI = [UIImage]()
var markLocations = [String]()
var markDescriptions = [String]()
var markDates = [NSDate]()
var markPooNames = [String]()
var markObjectIDs = [String]()





class PooBrain{
    
    var userLocation = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var pooImages = [PFFile]()

    var coordinates = [CLLocationCoordinate2D]()
    var locations = [String]()
    var descriptions = [String]()
    var markers = [GMSMarker]()
    var dates = [NSDate]()
    var pooImagesUI = [UIImage]()
    var imageNames = [String]()
    var pooNames = [String]()
    var objectIDs = [String]()
    
    
    var markerAccLabel = 0
    var dup = false
    

    
//    var mVC = MapViewController()
    
    func getLocation(mapView: GMSMapView){
    userLocation = mapView.camera.target
        print("userLocation updated")
    }
    
    
    func savePoo(location: String, description: String, date: String){
        if userLocation.latitude != 0 && userLocation.longitude != 0 {
    
            let pooMarker = PFObject(className: "PooMarker")
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "E MMM d, h:mm a, yyyy"
            let rD = dateformatter.date(from: "\(date)")!

  //          let imageData = UIImagePNGRepresentation(currentPoo!)
  //          let imageFile = PFFile(data: imageData!)
 //           let imageName = currentPoo.image.
    
            pooMarker["userid"] = PFUser.current()?.objectId!
            if addBool == false {
            pooMarker["location"] = PFGeoPoint(latitude: userLocation.latitude, longitude: userLocation.longitude)
            }else if addBool == true {
                print("tapmarker lat\(tapMarker.position.latitude)")
                pooMarker["location"] = PFGeoPoint(latitude: tapMarker.position.latitude, longitude: tapMarker.position.longitude)
            }
 //           pooMarker["pooImage"] = imageFile
            pooMarker["restorationID"] = currentPooString
            pooMarker["locationDescription"] = location
            pooMarker["descriptionDescription"] = description
            pooMarker["dateDescription"] = rD
            
            
            do  {
                try pooMarker.save()
            }
                catch {
                    print("Failed to save")
            }

            print("current poo \(currentPoo)")
        }
        
        else {
            displayAlert(title: "Location not working", message: "Please try again")
        }
    }
    
    func updatePoo(location: String, description: String, date: String, objectID: String){
        
        var query = PFQuery(className: "PooMarker")
        var object = PFObject(className: "PooMarker")
        
        query.getObjectInBackground(withId: objectID) { (pooMarker, error) in
            if error != nil {
                print(error)
            } else if let pooMarker = pooMarker {
                
                let dateformatter = DateFormatter()
                dateformatter.dateFormat = "E MMM d, h:mm a, yyyy"
                let rD = dateformatter.date(from: "\(date)")!
                
                pooMarker["locationDescription"] = location
                pooMarker["descriptionDescription"] = description
                pooMarker["dateDescription"] = rD
                pooMarker.saveInBackground()
                
                
            }
        }
        

    }
    
    func queryAndStore(){
    
        let query = PFQuery(className: "PooMarker")
    
//        pooImages.removeAll()
        coordinates.removeAll()
        locations.removeAll()
        descriptions.removeAll()
        markers.removeAll()
        dates.removeAll()
        pooNames.removeAll()
        objectIDs.removeAll()
    
        query.whereKey("userid", equalTo: (PFUser.current()?.objectId)!)
        query.order(byDescending: "dateDescription")

    
        do {
    
            let users = try query.findObjects()
    
            if let users = users as? [PFObject] {
    
                for user in users {
    
  //                  self.pooImages.append(user["pooImage"] as! PFFile)
                    self.pooNames.append(user["restorationID"] as! String)
                    self.coordinates.append(CLLocationCoordinate2D(latitude: (user["location"] as AnyObject).latitude, longitude: (user["location"] as AnyObject).longitude))
                    self.locations.append(user["locationDescription"] as! String)
                    self.descriptions.append(user["descriptionDescription"] as! String)
                    self.dates.append(user["dateDescription"] as! NSDate)
                    self.objectIDs.append(user.objectId! as String)
                    
    
                }
            }
        } catch {
            print ("Could not get users")
        }
        print("locations count: \(locations.count)")
    }
 
    func loopCoordinates(){
        var i = 0
 //       pooImagesUI.removeAll()
        
        if coordinates.count > 0 {
    
            for coordinate in coordinates {
                let pooMarkerMap = GMSMarker(position: coordinate)
   //             pooMarkerMap.title = locations[i]
   //             pooMarkerMap.snippet = descriptions[i]
  //            pooMarkerMap.tracksInfoWindowChanges = true
  //              pooImages[i].getDataInBackground { (data, error) in
  //                  if let imageData = data {
  //                      if let pooImageIcon = UIImage(data: imageData){
                let pooMarkerImage = UIImage(named: pooNames[i])
                pooMarkerMap.icon = imageWithImage(image: pooMarkerImage!, scaledToSize: CGSize(width: 40.0, height: 40.0))
                pooMarkerMap.accessibilityLabel = "\(i)"
    //                        pooImagesUI.append(pooMarkerMap.icon!)

                markers.append(pooMarkerMap)
                i += 1
                        }
                        
                    }

                }
                

                


    
    
        




    func placeMarkers(mapView: GMSMapView){
        var i = 0
        let newMarkers = removeDuplicates(values: markers)
        for marker in newMarkers {
//            marker.accessibilityLabel = "\(i)"
            marker.map = mapView
            marker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
//            marker.
//            marker.infoWindowAnchor = CGPoint(x: 0.5, y: 0.2)
//            marker.accessibilityLabel = "\(i)"
            i += 1
        }
        print("markers = \(markers)")
    }
 
    
    
    func displayAlert(title: String, message: String){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        let mapViewController: MapViewController = MapViewController(nibName: nil, bundle: nil)
 //       var value = myCustomViewController.someVariable

        
        mapViewController.present(alertController, animated: true, completion: nil)
    }
    
    func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        image.draw(in: CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: newSize.width, height: newSize.height)))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }

func printStuff(){
    print ("func print stuff")
}

    func formatDate(dateInput: NSDate) -> String{
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.short
        formatter.timeStyle = .short
    
        let dateString = formatter.string(from: dateInput as Date)
        return dateString
    }
    
    func removeDuplicates(values: [GMSMarker]) -> [GMSMarker] {
        // Convert array into a set to get unique values.
//        let uniques = Set<GMSMarker>(values)
        var newArray = [GMSMarker]()

        for value in values {
            dup = false
            for newElement in newArray {
                if newElement.position.latitude == value.position.latitude {
                    dup = true
                }
            }
            if dup == false {
            newArray.append(value)
        }
    }
        
        
        return newArray
    }
    
    func markerLocationList(){
    
        var compareLocation = CLLocationCoordinate2D(latitude: tapMarker.position.latitude, longitude: tapMarker.position.longitude)
/*
        var markPooImagesUI = [UIImage]()
 //       var markCoordinates: [CL]
        var markLocations = [String]()
        var markDescriptions = [String]()
        var markDates = [NSDate]()
 
 */
        var i = 0
        
        markPooImages.removeAll()
        markPooImagesUI.removeAll()
        markLocations.removeAll()
        markDescriptions.removeAll()
        markDates.removeAll()
        markPooNames.removeAll()
        markObjectIDs.removeAll()

    
        for coordinate in coordinates{
            if coordinate.latitude == compareLocation.latitude {
                
                print("mark table added")
                print("pooImgagesUI count: \(pooImagesUI.count)")
                

  //              markPooImagesUI.append(pooImagesUI[i])
                markLocations.append(self.locations[i])
                markDescriptions.append(self.descriptions[i])
                markDates.append(self.dates[i])
                markPooNames.append(self.pooNames[i])
                markObjectIDs.append(self.objectIDs[i])
                
                        }
            
            
            i = i + 1
            print(i)
        }
    }
    
//    func convertMark(file: PFfile){
        
//    }
    
    func deletePoo(index: Int){
        let objectID = objectIDs[index]
        let query = PFQuery(className: "PooMarker")
        query.whereKey("objectId", equalTo: objectID)
        
        
        query.findObjectsInBackground(block: { (objects, error) in
            if error != nil {
                print("THERE WAS AN ERROR DELETING THE OBJECT")
            }else{
                for object in objects!{

                    object.deleteInBackground()

                }
            }
        })
        
        
    }
    
}



