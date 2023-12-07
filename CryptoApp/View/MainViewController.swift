//
//  ViewController.swift
//  CryptoApp
//
//  Created by Batuhan Berk Ertekin on 21.09.2023.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var cryptoArray  : [Crypto] = [Crypto] ()
    var searchArray  : [Crypto] = [Crypto] ()
    
    var mainViewModel = MainViewModel()
    
    var isSearching = false
  
    override func viewDidLoad() {
        super.viewDidLoad()
       
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
    
        _ = mainViewModel.cryptoArray.subscribe(onNext: { crypto in
            
            self.cryptoArray = crypto
        
            DispatchQueue.main.async {
                
                self.tableView.reloadData()
            }
            
        })
      }
    }

extension MainViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isSearching {
            
            return searchArray.count
            
        } else  {
            return cryptoArray.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =  UITableViewCell()
        var content = cell.defaultContentConfiguration()
        
        cell.layer.cornerRadius = 20
        cell.backgroundColor = .systemGreen
        cell.layer.borderWidth = 4.0
        cell.layer.masksToBounds = true
        cell.layer.borderColor = CGColor(gray: 5, alpha: 5)
        
        if isSearching {
            content.text = searchArray[indexPath.row].cryptoName
            content.secondaryText = String(searchArray[indexPath.row].cryptoPrice)
        } else {
            content.text = cryptoArray[indexPath.row].cryptoName
            content.secondaryText = String(cryptoArray[indexPath.row].cryptoPrice)
            
        }
        
        cell.contentConfiguration = content
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
}

extension MainViewController : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText == "" {
                  isSearching = false
               } else {
                   isSearching = true
                   // Add Data 
                   searchArray = cryptoArray.filter({$0.cryptoName.lowercased().contains(searchText.lowercased())})
               }
               
        tableView.reloadData()
        
    }
}

