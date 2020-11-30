//
//  SearchStore.swift
//  Stock Trader
//
//  Created by Dylan Ah Teck on 11/30/20.
//

import Foundation
import Alamofire
import SwiftUI

class SearchStore: ObservableObject {
    @Published var stocks: [Stock]
    
    init(stocks: [Stock] = []){
        self.stocks = stocks
    }
    
    public func fetchSuggestions(ticker: String){
        AF.request("http://test-env.eba-ufqt4wd9.us-east-1.elasticbeanstalk.com/autocomplete/\(ticker)").response { response in
            debugPrint(response)
        }
    }
}

var stocks: [Stock] = [
//    Stock(ticker: "AAPL", name: "Aaple", shares: 10.00, price: 111.20, change: -5.40),
//    Stock(ticker: "GOOG",  name: "Aaple",shares: 10.00, price: 111.20, change: -5.40),
//    Stock(ticker: "W",  name: "Aaple", shares: 10.00, price: 111.20, change: -5.40),
//    Stock(ticker: "MSFT", name: "Aaple", shares: 10.00, price: 111.20, change: -5.40)
]

//let testSearchStore = SearchStore(stocks: stocks)
