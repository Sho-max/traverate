//
//  placrDetailViewController.swift
//  Original App ver.2
//
//  Created by 石井　翔 on 2020/10/13.
//  Copyright © 2020 石井　翔. All rights reserved.
//

import UIKit
import NCMB
import Cosmos
import Hero
import MapKit
import Kingfisher

class placrDetailViewController: UIViewController,UITextViewDelegate, MKMapViewDelegate, CLLocationManagerDelegate{
    
    
    @IBOutlet weak var placeName: UINavigationItem!
    @IBOutlet weak var starRating: CosmosView!
    @IBOutlet weak var reviewTextView: UITextView!
    @IBOutlet weak var detailMapView: MKMapView!
    @IBOutlet weak var photoImgageView: UIImageView!
    
    
    var pointAno: MKPointAnnotation = MKPointAnnotation()
    var locManager: CLLocationManager!
    var latitude : Double!
    var longitude : Double!
    
    
    var passedPlaceName: String?
    var passedImageUrl: String?
    var passedStarRating: Double?
    var reviewText: String?
    var passedLatitude: Double!
    var passedLongitude: Double!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        placeName.title = passedPlaceName
        starRating.rating = passedStarRating!
        reviewTextView.text = reviewText!
        photoImgageView.kf.setImage(with: URL(string: passedImageUrl!), placeholder: UIImage(named: "imageGallery"))
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
           detailMapView.delegate = self
           loadPin()
           
       }
    //NCMBから読み込み
       func loadPin() {
           
                var pointAno3 : MKPointAnnotation = MKPointAnnotation()
                let x = self.passedLatitude
                let y = self.passedLongitude
                pointAno3.coordinate = CLLocationCoordinate2DMake(x!, y!)
                self.detailMapView.addAnnotation(pointAno3)
                   
               
        }
    
    
}
