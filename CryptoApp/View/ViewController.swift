//
//  ViewController.swift
//  CryptoApp
//
//  Created by Batuhan Berk Ertekin on 21.09.2023.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let url = URL(string:"http://data.fixer.io/api/latest?access_key=798c8fae3cd7d13011fca8fa483039f3")
    var cryptoArray  = [Crypto]()
  
    override func viewDidLoad() {
        super.viewDidLoad()
       
        tableView.dataSource = self
        tableView.delegate = self
        
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
        return cryptoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =  UITableViewCell()
        var content = cell.defaultContentConfiguration()
        content.text = cryptoArray[indexPath.row].cryptoName
        content.secondaryText = String(cryptoArray[indexPath.row].cryptoPrice)
        cell.contentConfiguration = content
        
        
        cell.layer.cornerRadius = 20
        cell.backgroundColor = .systemGreen
        cell.layer.borderWidth = 2.0
        cell.layer.masksToBounds = true
        cell.layer.borderColor = CGColor(gray: 5, alpha: 5)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
    
}

