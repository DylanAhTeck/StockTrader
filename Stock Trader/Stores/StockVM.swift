//
//  StockVM.swift
//  Stock Trader
//
//  Created by Dylan Ah Teck on 12/1/20.
//

import Foundation
import SwiftUI
import Alamofire
import SwiftyJSON

class StockVM: ObservableObject {
    @Published var stock: Stock
    @Published var stats: Stats = Stats()
    init(stock: Stock) {
        self.stock = stock
        self.retrieveStockInformation()
    }
    
    func retrieveStockInformation(){
        AF.request("http://test-env.eba-ufqt4wd9.us-east-1.elasticbeanstalk.com/details/price/\(stock.ticker)", method: .get, encoding: JSONEncoding.default)
            .responseJSON {
            (response) in
                switch response.result {
                case .success(let data):
                    let json = JSON(data)
                    if let statsArray = json.to(type: Stats.self){
                        let arr  = statsArray as! [Stats]
                        self.stats = arr[0]
                    }
                case .failure(let error):
                    print(error)
                }
        }
    }

}
