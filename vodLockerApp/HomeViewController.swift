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
    
    var itemArray = [[String:Any]]()
    
    var movieResults = [[String: Any]]()
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! ViewController
        
        vc.movieTitle = self.movieTitle
        
    }
    
}

extension HomeViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let search = searchController.searchBar.text
        
        var searchUrl: String?
        
        if let search = search {
            searchUrl = "https://api.themoviedb.org/3/search/movie?api_key=d29f64f3d27a5652e751dbfbb60bcb73&query=\(search)"
        } else {
            print("Nothing found")
        }
        
        if let searchUrl = searchUrl {
            Alamofire.request(searchUrl).responseJSON { response in
                let dictionary =
                   try? JSONSerialization
                        .jsonObject(with: response.data!,
                                    options: .mutableContainers)
                    as! [String: Any]
                
                OperationQueue.main.addOperation {
                    self.movieResults = self.dictionary["results"] as! [[String: Any]]
                    //print(self.movieResults)
                    self.tableView.reloadData()
                }
        
            }
        }
    }
}

extension HomeViewController: UISearchControllerDelegate {
    
}


extension HomeViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("starting to edit")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let search = searchBar.text!
        let searchUrl = "https://api.themoviedb.org/3/search/movie?api_key=d29f64f3d27a5652e751dbfbb60bcb73&query=\(search)"
        
        Alamofire.request(searchUrl).responseJSON { response in
            let dictionary =
                try? JSONSerialization.jsonObject(with: response.data!, options: .mutableContainers) as! [String: Any]
            
            print(dictionary ?? ["This is a test" : "guy"])
        }
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
        
        if self.searchController.isActive &&
            self.searchController.searchBar.text != "" {
            
            let item: [String: Any] = self.movieResults[indexPath.row]
            
            cell.textLabel?.text = item["original_title"] as? String
            cell.detailTextLabel?.text = String(describing: item["vote_count"] as! Int)
            
            /*
            cell.textLabel?.text = item["original_title"] as? String
            cell.detailTextLabel?.text = String(describing: item["vote_count"] as! Int)*/
            
        } else {
        
        Alamofire.request(popularityUrl).responseJSON { response in
            self.dictionary =
                try! JSONSerialization.jsonObject(with: response.data!, options: .mutableContainers) as! [String: Any]
            
            OperationQueue.main.addOperation {
                
                    self.itemArray = self.dictionary["results"] as! [[String: Any]]
                    let item = self.itemArray[indexPath.row] as [String: Any]
                    
                    cell.textLabel?.text = item["title"] as? String
                    cell.detailTextLabel?.text = String(describing: item["vote_count"] as! Int)
                }
                
                
                
            }
       
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let stringToFormat = self.itemArray[indexPath.row]["title"] as! String
        
        let stringArr = stringToFormat.components(separatedBy: " ")
        
        var newString = ""
        for i in 0...stringArr.count-1 {
            if stringArr[i] != stringArr.last {
                newString = newString + stringArr[i] + "_"
            } else {
                newString = newString + stringArr[i]
                break
            }
        }
        
        self.movieTitle = newString
        
        self.performSegue(withIdentifier: "toVideo", sender: self)
    }
}
