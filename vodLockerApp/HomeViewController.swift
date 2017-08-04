//
//  HomeViewController.swift
//  vodLockerApp
//
//  Created by Colin Walsh on 8/4/17.
//  Copyright © 2017 Colin Walsh. All rights reserved.
//

import UIKit
import Alamofire

class HomeViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var dictionary: Dictionary = [String: Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        self.tableView.tableHeaderView = searchController.searchBar
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let id = 550
        let key = "d29f64f3d27a5652e751dbfbb60bcb73"
        let url = "https://api.themoviedb.org/3/movie/\(id)?api_key=\(key)"
        
        Alamofire.request(url).responseJSON { response in
            self.dictionary =
                try! JSONSerialization.jsonObject(with: response.data!, options: .mutableContainers) as! [String: Any]
            
//            print(dictionary)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension HomeViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        print("stuff")
    }
}

extension HomeViewController: UISearchControllerDelegate {
}


extension HomeViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("starting to edit")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("Searching for: \(String(describing: self.searchController.searchBar.text))")
    }
}


extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath)
        
        cell.textLabel?.text = "Hey"
        cell.detailTextLabel?.text = "There"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected cell")
    }
}
