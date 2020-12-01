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
    @Published var news: [NewsArticle] = []
    
    init(stock: Stock) {
        self.stock = stock
        self.getStats()
        self.getNews()
        self.getDescription()
    }
    
    func getStats(){
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
    
    func getNews(){
        AF.request("http://test-env.eba-ufqt4wd9.us-east-1.elasticbeanstalk.com/details/news/\(stock.ticker)", method: .get, encoding: JSONEncoding.default)
            .responseJSON {
            (response) in
                switch response.result {
                case .success(let data):
                    let json = JSON(data)
                    if let newsArray = json.to(type: NewsArticle.self){
                        self.news = newsArray as! [NewsArticle]
                    }
                case .failure(let error):
                    print(error)
                }
        }
    }
    
    func getDescription() {
        AF.request("http://test-env.eba-ufqt4wd9.us-east-1.elasticbeanstalk.com/details/description/\(stock.ticker)", method: .get, encoding: JSONEncoding.default)
            .responseJSON {
            (response) in
                switch response.result {
                case .success(let data):
                    let json = JSON(data)
                    if let stocksArray = json.to(type: Stock.self){
                        let stocksArr = stocksArray as! [Stock]
                        if stocksArr.count > 0 && stocksArr[0].description != "" {
                            self.stock.description = stocksArr[0].description
                        }
                    }
                case .failure(let error):
                    print(error)
                }
        }
    }

}
