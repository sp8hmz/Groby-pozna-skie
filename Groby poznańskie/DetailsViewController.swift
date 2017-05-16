//
//  DetailsViewController.swift
//  Groby poznańskie
//
//  Created by Karol Karczewski on 15.05.2017.
//  Copyright © 2017 Karol Karczewski. All rights reserved.
//

import UIKit
import MapKit

class DetailsViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var nameAndSurnameTextLabel: UILabel!
    @IBOutlet weak var birthDate: UILabel!
    @IBOutlet weak var deathDate: UILabel!
    @IBOutlet weak var exactLocation: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    var grave: Grave? {
        didSet {
            self.configureView()
        }
    }
    
    func configureView() {
        if let grave = self.grave {
            if let nameAndSurname = self.nameAndSurnameTextLabel, let birthDate = self.birthDate, let deathDate = self.deathDate, let mapView = self.mapView, let exactLocation = self.exactLocation {
                nameAndSurname.text = grave.nameAndSurname
                
                let calendar = Calendar.current
                let ageComponents = calendar.dateComponents(Set<Calendar.Component>([.year]), from: grave.birthDate, to: grave.deathDate)
                let age = ageComponents.year!
                
                let dateString = DateFormatter()
                dateString.dateFormat = "dd.MM.yyyy"
                birthDate.text = "Ur. \(dateString.string(from: grave.birthDate)) r."
                deathDate.text = "Zm. \(dateString.string(from: grave.deathDate)) r. (l. \(age)"
                
                exactLocation.text = "Kwatera \(grave.quarter), rząd \(grave.row), miejsce \(grave.place)"
                
                mapView.showsScale = true
                let point = MapPoint(title: "Grób", coordinate: grave.coordinates)
                mapView.addAnnotation(point)
                let region = MKCoordinateRegionMakeWithDistance(grave.coordinates, 500, 500)
                mapView.setRegion(region, animated: true)
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        self.configureView()
        // Do any additional setup after loading the view.
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
