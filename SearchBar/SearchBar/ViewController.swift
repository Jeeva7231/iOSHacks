//
//  ViewController.swift
//  SearchBar
//
//  Created by jeeva on 30/07/21.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchResultsUpdating, UISearchControllerDelegate {

    @IBOutlet weak var dishTableView: UITableView!
    
    var foodArray = [foodDetails]()
    var searchedFoodArray = [foodDetails]()
    
    var searching = false
    
    let searchCon = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dishTableView.delegate = self
        dishTableView.dataSource = self
        
        configSearchCon()
        
        let d1 = foodDetails(dName: "Briyani", dPrice: "Rs.100")
        foodArray.append(d1)
        let d2 = foodDetails(dName: "Pasta", dPrice: "Rs.200")
        foodArray.append(d2)
        let d3 = foodDetails(dName: "Desserts", dPrice: "Rs.300")
        foodArray.append(d3)
        let d4 = foodDetails(dName: "Pizza", dPrice: "Rs.400")
        foodArray.append(d4)
        let d5 = foodDetails(dName: "Burger", dPrice: "Rs.100")
        foodArray.append(d5)
    
        self.navigationItem.title = "Zomato"
    }
    
    //Configure Search View Controller
    
    private func configSearchCon() {
        searchCon.loadViewIfNeeded()
        searchCon.searchResultsUpdater = self
        searchCon.delegate = self
        searchCon.obscuresBackgroundDuringPresentation = false
        searchCon.searchBar.enablesReturnKeyAutomatically = false
        searchCon.searchBar.returnKeyType = UIReturnKeyType.done
        self.navigationItem.searchController = searchCon
        definesPresentationContext = true
    }
    
    //Protocol Stubs for TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return searchedFoodArray.count
        }
        else{
            return foodArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dishTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! foodTableViewCell
        
        if searching {
            cell.dishNameOutlet.text = searchedFoodArray[indexPath.row].dishName
            cell.dishPriceOutlet.text = searchedFoodArray[indexPath.row].dishPrice
        }
        else{
            cell.dishNameOutlet.text = foodArray[indexPath.row].dishName
            cell.dishPriceOutlet.text = foodArray[indexPath.row].dishPrice
        }
        
        return cell
    }
    
    //Protocol Stubs for Search Results Updating
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchCon.searchBar.text!
        
        if !searchText.isEmpty{
            searching = true
            searchedFoodArray.removeAll()
            for i in foodArray{
                if i.dishName.lowercased().contains(searchText.lowercased()){
                    searchedFoodArray.append(i)
                }
            }
        }
        else{
            searching = false
            searchedFoodArray.removeAll()
            searchedFoodArray = foodArray
        }
        dishTableView.reloadData()
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchedFoodArray.removeAll()
        dishTableView.reloadData()
    }
    
}

