//
//  MainViewModel.swift
//  CryptoApp
//
//  Created by Batuhan Berk Ertekin on 7.12.2023.
//

import Foundation
import RxSwift

class MainViewModel {
    
    var cryptoArray = BehaviorSubject<[Crypto]>(value: [Crypto]())
    
    var mainViewRepository = MainDaoRepository()
    
    init() {
       
        cryptoArray = mainViewRepository.cryptoArray
        loadCrypto()
    }
    
    func  loadCrypto() {
        mainViewRepository.loadCrypto()
        
    }
    
}
