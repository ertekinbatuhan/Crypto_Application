//
//  MainDaoRepository.swift
//  CryptoApp
//
//  Created by Batuhan Berk Ertekin on 7.12.2023.
//

import Foundation
import RxSwift


class MainDaoRepository {
    
    var cryptoArray = BehaviorSubject<[Crypto]>(value: [Crypto]())
   
    func loadCrypto() {
        
        let url = URL(string:"http://data.fixer.io/api/latest?access_key=798c8fae3cd7d13011fca8fa483039f3")
        
        var getDataArray = [Crypto]()
        
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
                                    
                                    getDataArray.append(cryptoData)
                                    
                                    self.cryptoArray.onNext(getDataArray)
                                    
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
