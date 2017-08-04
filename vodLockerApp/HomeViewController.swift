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
    
    var movieTitle: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        self.tableView.tableHeaderView = searchController.searchBar
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
 
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
        
        //let id = 550
        let key = "d29f64f3d27a5652e751dbfbb60bcb73"
        //let movieUrl = "https://api.themoviedb.org/3/movie/\(id)?api_key=\(key)"
        let popularityUrl = "https://api.themoviedb.org/3/discover/movie?api_key=\(key)&sort_by=popularity.desc"
        
        Alamofire.request(popularityUrl).responseJSON { response in
            self.dictionary =
                try! JSONSerialization.jsonObject(with: response.data!, options: .mutableContainers) as! [String: Any]
            
            OperationQueue.main.addOperation {
                let resultArray = self.dictionary["results"] as! [[String: Any]]
                
                let item = resultArray[indexPath.row] as [String: Any]
                
                cell.textLabel?.text = item["title"] as? String
                cell.detailTextLabel?.text = String(describing: item["vote_count"] as! Int)
            }
            //            print(dictionary)
        }
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath)
        
        self.movieTitle = (cell.textLabel?.text)!
        print(self.movieTitle)
        self.performSegue(withIdentifier: "toVideo", sender: self)
    }
}
