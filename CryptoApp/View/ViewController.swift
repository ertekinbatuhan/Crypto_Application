//
//  ViewController.swift
//  CryptoApp
//
//  Created by Batuhan Berk Ertekin on 21.09.2023.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    let url = URL(string:"http://data.fixer.io/api/latest?access_key=798c8fae3cd7d13011fca8fa483039f3")
    var cryptoArray  : [Crypto] = [Crypto] ()
    var searchList  : [Crypto] = [Crypto] ()
    
    var isSearching = false
  
    override func viewDidLoad() {
        super.viewDidLoad()
       
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        
        let session = URLSession.shared
        let task = session.dataTask(with: url!) { data, response, error in
            
            if error != nil {
                
                print(error!.localizedDescription)
                
            } else {
                
                if data != nil {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options : JSONSerialization.ReadingOptions.mutableContainers) as! [String : Any]
                        
                        DispatchQueue.main.async {
                            
                            if let rates = json["rates"] as? [String : Any] {
                        
                                for crypto in rates {
                    
                                    let cryptoData = Crypto(cryptoName: crypto.key, cryptoPrice: crypto.value as! Double)
                                    
                                    self.cryptoArray.append(cryptoData)
                                    self.tableView.reloadData()
                                                                
                                }
                            }
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                    
                } else {
                    
                }
                
            }
            
        }
        task.resume()
        
    }


}

extension ViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isSearching {
            
            return searchList.count
            
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
            content.text = searchList[indexPath.row].cryptoName
            content.secondaryText = String(searchList[indexPath.row].cryptoPrice)
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

extension ViewController : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText == "" {
                  isSearching = false
               } else {
                   isSearching = true
                   searchList = cryptoArray.filter({$0.cryptoName.lowercased().contains(searchText.lowercased())})
               }
               
        tableView.reloadData()
        
    }
    
    
}

