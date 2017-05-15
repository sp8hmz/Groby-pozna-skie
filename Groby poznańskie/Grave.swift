//
//  Grave.swift
//  Groby poznańskie
//
//  Created by Karol Karczewski on 15.05.2017.
//  Copyright © 2017 Karol Karczewski. All rights reserved.
//

import Foundation

class Grave {
    var nameAndSurname: String = ""
    var name: String = ""
    var surname: String = ""
    var id: Int = 0
    
    init(nameAndSurname: String, name: String, surname: String, id: Int) {
        self.nameAndSurname = nameAndSurname
        self.name = name
        self.surname = surname
        self.id = id
    }
}
