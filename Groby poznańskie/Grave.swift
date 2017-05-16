//
//  Grave.swift
//  Groby poznańskie
//
//  Created by Karol Karczewski on 15.05.2017.
//  Copyright © 2017 Karol Karczewski. All rights reserved.
//

import Foundation
import MapKit

class Grave {
    var nameAndSurname = String()
    var name = String()
    var surname = String()
    var id = Int()
    var birthDate = Date()
    var deathDate = Date()
    var coordinates = CLLocationCoordinate2D()
    var quarter = String()
    var row = Int()
    var place = Int()
    
    init(nameAndSurname: String, name: String, surname: String, birthDate: Date, deathDate: Date, id: Int, coordinates: CLLocationCoordinate2D, quarter: String, row: Int, place: Int) {
        self.nameAndSurname = nameAndSurname
        self.name = name
        self.surname = surname
        self.birthDate = birthDate
        self.deathDate = deathDate
        self.id = id
        self.coordinates = coordinates
        self.quarter = quarter
        self.row = row
        self.place = place
    }
}
