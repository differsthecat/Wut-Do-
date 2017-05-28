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

    var region: MKCoordinateRegion? {
        didSet {
            if let region = region {
                startProcessing(region: region)
            }
        }
    }

    private var localSearch: MKLocalSearch?
    
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
            print(response)
        }
    }
}
