//
//  MapPoint.swift
//  Groby poznańskie
//
//  Created by Karol Karczewski on 16.05.2017.
//  Copyright © 2017 Karol Karczewski. All rights reserved.
//

import MapKit
import UIKit

class MapPoint: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    
    init(title: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
    }
}
