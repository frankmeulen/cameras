//
//  ViewController.swift
//  Infi_test
//
//  Created by Frank van der Meulen on 18-01-18.
//  Copyright © 2018 Frank van der Meulen. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var mapButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var camera: CameraDataModel!
    var cameras = [CameraDataModel]()
    var kCSVFileName = "cameras-defb"
    var kCSVFileExtension = "csv"
    var list3 = [CameraDataModel]()
    var list5 = [CameraDataModel]()
    var list3en5 = [CameraDataModel]()
    var listNone = [CameraDataModel]()
    var cameraData: CameraDataModel!
    var filteredCameras = [CameraDataModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Cameras"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        var data = readDataFromCSV(fileName: kCSVFileName, fileType: kCSVFileExtension)
        data = cleanRows(file: data!)
        
        self.cameras = csv(data: data!)
        print(self.cameras)
        
        for item in self.cameras {
            let camNumber = Int(String(describing: item.cameraNaam[7...9]))!
            if (camNumber % 3 == 0) {
                if camNumber % 5 == 0 {
                    list3en5.append(item)
                }
                else {
                    list3.append(item)
                }
            }
            else if camNumber % 5 == 0 {
                list5.append(item)
            }
            else {
                listNone.append(item)
            }
        }
        print("list3en5",list3en5)
        print("list3",list3)
        print("list5",list5)
        print("listNone",listNone)
        print("Cameras", self.cameras)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "MapSegue" {
            
            let nextVC = segue.destination as! MapViewController
            nextVC.camerasArray = self.cameras
        }
    }
    
    func csv(data: String) -> [CameraDataModel] {
        var result: [CameraDataModel] = []
        let rows = data.components(separatedBy: "\n")
        for row in rows {
            if row != "" && row != rows[0] {
                let columns = row.components(separatedBy:  ";")
                
                camera = CameraDataModel(cameraNaam: columns[0], cameraLatitude: columns[1], cameraLongitude: columns[2])
                if camera != nil  {
                    result.append(camera)
                }
            }
        }
        return result
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if isFiltering() {
            return 1
        }
        
        return 4
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if isFiltering() {
            return "Filtered Cameras"
        }
        else {
            if section == 0 {
                return "Divisable by 3"
            }
            if section == 1 {
                return "Divisable by 5"
            }
            if section == 2 {
                return "Divisable by 3 and 5"
            }
            if section == 3 {
                return "Not divisable by 3 and 5"
            }
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFiltering() {
            return filteredCameras.count
        }
        
        if section == 0 {
            return list3.count
        }
        if section == 1 {
            return list5.count
        }
        if section == 2 {
            return list3en5.count
        }
        if section == 3 {
            return listNone.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:CameraCell = tableView.dequeueReusableCell(withIdentifier: "cameraCell", for: indexPath) as! CameraCell
        
        if isFiltering() {
            self.cameraData = filteredCameras[indexPath.row]
        }
        else {
            if indexPath.section == 0 {
                self.cameraData = list3[indexPath.row]
            }
            if indexPath.section == 1{
                self.cameraData = list5[indexPath.row]
            }
            if indexPath.section == 2{
                self.cameraData = list3en5[indexPath.row]
            }
            if indexPath.section == 3{
                self.cameraData = listNone[indexPath.row]
            }
        }
        cell.CameraNaam.text = self.cameraData.cameraNaam
        cell.cameraNummer.text = String(describing: self.cameraData.cameraNaam[7...9])
        cell.cameraLatitude.text = self.cameraData.cameraLatitude
        cell.cameraLongitude.text = self.cameraData.cameraLongitude
        
        return cell
    }
    
    func cleanRows(file:String)->String{
        var cleanFile = file
        cleanFile = cleanFile.replacingOccurrences(of: "\r", with: "\n")
        cleanFile = cleanFile.replacingOccurrences(of: "\n\n", with: "\n")
        return cleanFile
    }
    
    func readDataFromCSV(fileName:String, fileType: String)-> String!{
        guard let filepath = Bundle.main.path(forResource: fileName, ofType: fileType)
            else {
                return nil
        }
        do {
            var contents = try String(contentsOfFile: filepath, encoding: .utf8)
            contents = cleanRows(file: contents)
            return contents
        } catch {
            print("File Read Error for file \(filepath)")
            return nil
        }
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredCameras = self.cameras.filter({( camera: CameraDataModel) -> Bool in
            return camera.cameraNaam.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    @IBAction func mapButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "MapSegue", sender: self)
    }
}

extension String {
    subscript (bounds: CountableClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start...end])
    }
    
    subscript (bounds: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start..<end])
    }
}

extension ViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}


