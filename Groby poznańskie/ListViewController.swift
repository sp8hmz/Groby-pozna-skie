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
import KRProgressHUD

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var isSearching = false
    
    var graves = [Grave]()
    var filteredGraves = [Grave]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
        searchBar.setValue("Anuluj", forKey:"cancelButtonText")
        getData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let row = tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: row, animated: false)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getData() {
        KRProgressHUD.show(message: "Ładowanie")
        Alamofire.request("http://www.poznan.pl/featureserver/featureserver.cgi/groby/all.json?maxfeatures=200").validate().responseData { response in
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
                KRProgressHUD.dismiss()
            } else {
                KRProgressHUD.dismiss()
                let alertController = UIAlertController(title: "Error", message:
                    "Wystąpił błąd podczas pobierania danych z serwera. Spróbuj ponownie.", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
                
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }


    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return filteredGraves.count
        } else {
            return graves.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ListTableCell
        let grave: Grave?
        if isSearching {
            grave = filteredGraves[indexPath.row]
        } else {
            grave = graves[indexPath.row]
        }
        cell.nameAndSurnameTextLabel.text = grave!.nameAndSurname
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let grave: Grave?
                if isSearching {
                    grave = filteredGraves[indexPath.row]
                } else {
                    grave = graves[indexPath.row]
                }
                let controller = segue.destination as! DetailsViewController
                controller.grave = grave!
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" || searchBar.text?.isEmpty == true {
            isSearching = false
            view.endEditing(true)
            tableView.reloadData()
        } else {
            isSearching = true
            filteredGraves = graves.filter({$0.nameAndSurname.contains(searchBar.text!)}    )
            tableView.reloadData()
        }
    }

}

