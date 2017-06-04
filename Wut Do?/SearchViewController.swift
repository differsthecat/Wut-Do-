//
//  SearchViewController.swift
//  Wut Do?
//
//  Created by Michael MacCallum on 5/28/17.
//  Copyright © 2017 Robyn Cute. All rights reserved.
//

import UIKit
import MapKit

class SearchViewController: UIViewController {
    @IBOutlet fileprivate weak var tableView: UITableView!

    var region: MKCoordinateRegion? {
        didSet {
            if let region = region {
                startProcessing(region: region)
            }
        }
    }
    
//    let otherData = ["hello", "robyn", "how", "are", "you", "?"]

    private var localSearch: MKLocalSearch?
    fileprivate var mapItems = [MKMapItem]() {
        didSet {
            tableView.reloadData()
            
//            tableView.reloadSections(
//                IndexSet(integer: 0),
//                with: .fade
//            )
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        localSearch?.cancel()
    }
    
    private func startProcessing(region: MKCoordinateRegion) {
        if let currentSearch = localSearch {
            currentSearch.cancel()
            localSearch = nil
        }
        
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = "restaurant"
        request.region = region

        localSearch = MKLocalSearch(request: request)
        localSearch!.start { response, error in
//            print(response)
//            for item in response!.mapItems {
//                print("Name = \(item.name)")
//            }
            guard let response = response else {
                return
            }
            
            self.mapItems = response.mapItems
        }
    }
}

extension SearchViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return mapItems.count
        
//        if section == 0 {
//            return mapItems.count
//        }
//        
//        return otherData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath)

        let mapItem = mapItems[indexPath.row]
                      cell.textLabel?.text = mapItem.name
        
//        if indexPath.section == 0 {
//            let mapItem = mapItems[indexPath.row]
//            cell.textLabel?.text = mapItem.name
//        } else {
//            let str = otherData[indexPath.row]
//            cell.textLabel?.text = str
//        }
        
        return cell
    }
}

extension SearchViewController: UITableViewDelegate {
    
}







