//
//  ViewController.swift
//  Groby poznańskie
//
//  Created by Karol Karczewski on 15.05.2017.
//  Copyright © 2017 Karol Karczewski. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MapKit

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var graves = [Grave]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        getData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getData() {
        Alamofire.request("http://www.poznan.pl/featureserver/featureserver.cgi/groby/all.json?maxfeatures=100").validate().responseData { response in
            if let _ = response.result.value {
                let parsedJSON = JSON(data: response.result.value!)
                
                for i in 0..<parsedJSON["features"].count {
                    var nameAndSurname = parsedJSON["features"][i]["properties"]["print_surname_name"].stringValue
                    let name = parsedJSON["features"][i]["properties"]["print_name"].stringValue
                    let surname = parsedJSON["features"][i]["properties"]["print_surname"].stringValue
                    if nameAndSurname == "" {
                        nameAndSurname = "\(surname) \(name)"
                    }
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    let birthDate = dateFormatter.date(from: parsedJSON["features"][i]["properties"]["g_date_birth"].stringValue)
                    let deathDate = dateFormatter.date(from: parsedJSON["features"][i]["properties"]["g_date_death"].stringValue)
                    let id = parsedJSON["features"][i]["id"].intValue
                    let lon = parsedJSON["features"][i]["geometry"]["coordinates"][0][0].doubleValue
                    let lat = parsedJSON["features"][i]["geometry"]["coordinates"][0][1].doubleValue
                    let coordinates = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                    let quarter = parsedJSON["features"][i]["properties"]["g_quarter"].stringValue
                    let row = parsedJSON["features"][i]["properties"]["g_row"].intValue
                    let place = parsedJSON["features"][i]["properties"]["g_place"].intValue
                    
                    let grave = Grave(nameAndSurname: nameAndSurname, name: name, surname: surname, birthDate: birthDate!, deathDate: deathDate!, id: id, coordinates: coordinates, quarter: quarter, row: row, place: place)
                    self.graves.append(grave)
                }
                self.tableView.reloadData()
            } else {
                //Error
            }
        }
    }


    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return graves.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ListTableCell
        
        let grave = graves[indexPath.row]

        cell.nameAndSurnameTextLabel.text = grave.nameAndSurname
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let grave = graves[indexPath.row]
                let controller = segue.destination as! DetailsViewController
                controller.grave = grave
            }
        }
    }

}

