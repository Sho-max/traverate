//
//  SearchViewController.swift
//  Original App ver.2
//
//  Created by 石井　翔 on 2020/09/20.
//  Copyright © 2020 石井　翔. All rights reserved.
//

import UIKit
import NCMB
import SVProgressHUD
import MapKit

class SearchViewController: UIViewController, UISearchBarDelegate, UIGestureRecognizerDelegate, MKMapViewDelegate {
    
    
    @IBOutlet weak var searchMap: MKMapView!
    @IBOutlet weak var zoomInButton: UIButton!
    @IBOutlet weak var zoomOutButton: UIButton!
    
    var pointAno: MKPointAnnotation = MKPointAnnotation()
    
    @IBOutlet var longPressGesRec: UILongPressGestureRecognizer!
    
    var searchBar: UISearchBar!
    var manager: CLLocationManager!
    let goldenRatio = 1.618
    var myLock = NSLock()
    
    var detailId = [String]()
    var detailsub = [String]()
    var detailImage = [String]()
    var detailtext = [String]()
    var likes = [Bool]()
    var smileCounts = [Int]()
    var userImages = [String]()
    var userNames = [String]()
    var blockUserIdArray = [String]()
    
    var nextId : String?
    var nextText : String?
    var nextTitle: String?
    var nextImage: String?
    
    
    
    var new:Bool?
    
    var latitude : Double!
    var longitude : Double!
    var latitudes = [Double]()
    var longitudes = [Double]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSearchBar()
        searchBar.delegate = self
        manager =  CLLocationManager()
        manager.startUpdatingLocation()
        manager.requestWhenInUseAuthorization()
        
        searchMap.showsUserLocation = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        searchMap.delegate = self
        
        loadPin()
    }
    override func didReceiveMemoryWarning() {
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations:[CLLocation]) {
        let longitude = (locations.last?.coordinate.longitude.description)!
        let latitude = (locations.last?.coordinate.latitude.description)!
        print("[DBG]longitude : " + longitude)
        print("[DBG]latitude : " + latitude)
        
        searchMap.setCenter((locations.last?.coordinate)!, animated: true)
    }
    
    
    
    
    func setSearchBar() {
        //         NavigationBarにSearchBarをセット
        if let navigationBarFrame = self.navigationController?.navigationBar.bounds {
            let searchBar: UISearchBar = UISearchBar(frame: navigationBarFrame)
            searchBar.delegate = self
            searchBar.placeholder = "お気に入りの場所を検索"
            searchBar.autocapitalizationType = UITextAutocapitalizationType.none
            navigationItem.titleView = searchBar
            navigationItem.titleView?.frame = searchBar.frame
            self.searchBar = searchBar
        }
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
        
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchBar.text
        request.region = searchMap.region
        
        let localSearch: MKLocalSearch = MKLocalSearch(request: request)
        localSearch.start { (result, error) in
            for placemark in (result?.mapItems)! {
                if(error == nil) {
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = CLLocationCoordinate2DMake(placemark.placemark.coordinate.latitude,placemark.placemark.coordinate.longitude)
                    annotation.title = placemark.placemark.name
                    annotation.subtitle = placemark.placemark.title
                    self.searchMap.addAnnotation(annotation)
                    
                }else{
                    print(error)
                }
            }
        }
    }
    @IBAction func zoomInAction(_ sender: Any) {
        print("[DBG]clickZoomin")
        myLock.lock()
        if (0.005 < searchMap.region.span.latitudeDelta / goldenRatio) {
            print("[DBG]latitudeDelta-1 : " + searchMap.region.span.latitudeDelta.description)
            var regionSpan:MKCoordinateSpan = MKCoordinateSpan()
            regionSpan.latitudeDelta = searchMap.region.span.latitudeDelta / goldenRatio
            searchMap.region.span = regionSpan
            print("[DBG]latitudeDelta-2 : " + searchMap.region.span.latitudeDelta.description)
        }
        myLock.unlock()
    }
    @IBAction func zoomOutAction(_ sender: Any) {
        print("[DBG]clickZoomout")
        myLock.lock()
        if (searchMap.region.span.latitudeDelta * goldenRatio < 150.0) {
            print("[DBG]latitudeDelta-1 : " + searchMap.region.span.latitudeDelta.description)
            var regionSpan:MKCoordinateSpan = MKCoordinateSpan()
            regionSpan.latitudeDelta = searchMap.region.span.latitudeDelta * goldenRatio
            //            regionSpan.latitudeDelta = mapView.region.span.longitudeDelta * GoldenRatio
            searchMap.region.span = regionSpan
            print("[DBG]latitudeDelta-2 : " + searchMap.region.span.latitudeDelta.description)
        }
        myLock.unlock()
    }
    
    //NCMBから読み込み
    func loadPin() {
        let query = NCMBQuery(className: "Post")
        
        query?.findObjectsInBackground({ (result, error) in
            if error != nil {
                
            }else {
                self.detailId = []
                
                let objects = result as! [NCMBObject]
                for object in objects{
                    
                    let user = object.object(forKey: "user") as! NCMBUser
                    // 退会済みユーザーの投稿を避けるため、activeがfalse以外のモノだけを表示
                    if user.object(forKey: "active") as? Bool != false {
                        
                        let latitude = object.object(forKey: "latitude") as! Double
                        let longitude = object.object(forKey: "longitude") as! Double
                        
                        // 投稿の情報を取得
                        let text = object.object(forKey: "placeName") as! String
                        let sub  = object.object(forKey: "text") as! String
                        
                        self.detailId.append(object.objectId)
                        self.detailtext.append(text)
                        self.detailsub.append(sub)
                        self.latitudes.append(latitude)
                        self.longitudes.append(longitude)
                    }
                    }
                    
                    
                    //複数ピンをfor文を回して立てる
                    for i in 0...self.detailId.count{
                        
                        if i == self.detailId.count {
                            break
                        }else {
                            var pointAno3 : MKPointAnnotation = MKPointAnnotation()
                            pointAno3.title = self.detailtext[i]
                            pointAno3.subtitle = self.detailsub[i]
                            let x = self.latitudes[i]
                            let y = self.longitudes[i]
                            pointAno3.coordinate = CLLocationCoordinate2DMake(x, y)
                            self.searchMap.addAnnotation(pointAno3)
                            continue
                        }
                        
                    }
                    
                }
            }
            )}
        
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if annotation is MKUserLocation {
                return nil
            }
            
            let reuseId = "pin"
            var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
            if pinView == nil {
                pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                pinView?.animatesDrop = false
                pinView?.pinTintColor = UIColor.red
                pinView?.canShowCallout = true
                let rightButton: AnyObject! = UIButton(type: UIButton.ButtonType.detailDisclosure)
                //            pinView?.rightCalloutAccessoryView = rightButton as? UIView
            }
            else {
                pinView?.annotation = annotation
            }
            return pinView
        }
        
        
        
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            //処理
        }
        
        
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGesture(gestureRecognizer:)))
            
            
            if self.detailId.count != 0{
                for i in 0...self.detailId.count{
                    if i == self.detailId.count {
                        break
                    }else {
                        if (view.annotation!.title!)! == self.detailtext[i]{
                            
                            self.nextId = self.detailId[i]
                            self.nextText = self.detailtext[i]
                            self.nextTitle = self.detailsub[i]
                            new = true
                        }else{
                            
                        }
                    }
                }
            }
            view.addGestureRecognizer(tapGesture)
        }
        @objc func tapGesture(gestureRecognizer: UITapGestureRecognizer){
            let view = gestureRecognizer.view
            let tapPoint = gestureRecognizer.location(in: view)
            //ピン部分のタップだったらリターン
            if tapPoint.x >= 0 && tapPoint.y >= 0 {
                return
            }
            
        }
        
}











