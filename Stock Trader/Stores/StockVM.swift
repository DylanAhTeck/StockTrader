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
    
    //Old url: http://test-env.eba-ufqt4wd9.us-east-1.elasticbeanstalk.com
    private let url = "http://stocktraderbackend-env.eba-xpqeibcm.us-east-1.elasticbeanstalk.com"
    @Published var stock: Stock
    @Published var stats: Stats = Stats()
    @Published var news: [NewsArticle] = []
    
    //@ObservedObject var favoritesVM: FavoritesVM
    
    init(stock: Stock) {
        self.stock = stock
//        self.favoritesVM = favoritesVM
        self.getStats()
        self.getNews()
        self.getDescription()
    }
    
    func getLatestPrice() {
        AF.request("\(self.url)/details/price/\(stock.ticker)", method: .get, encoding: JSONEncoding.default)
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
    
    func getStats(){
        AF.request("\(self.url)/details/price/\(stock.ticker)", method: .get, encoding: JSONEncoding.default)
            .responseJSON {
            (response) in
                switch response.result {
                case .success(let data):
                    let json = JSON(data)
                    if let statsArray = json.to(type: Stats.self){
                        let arr  = statsArray as! [Stats]
                        self.stats = arr[0]
                        self.stats.change = self.stats.last - self.stats.prevClose
                    }
                case .failure(let error):
                    print(error)
                }
        }
    }
    
    func getNews(){
        AF.request("\(self.url)/details/news/\(stock.ticker)", method: .get, encoding: JSONEncoding.default)
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
        AF.request("\(self.url)/details/description/\(stock.ticker)", method: .get, encoding: JSONEncoding.default)
            .responseJSON {
            (response) in
                switch response.result {
                case .success(let data):
                    let json = JSON(data)
                    if let stocksArray = json.to(type: Stock.self){
                        let stocksArr = stocksArray as! [Stock]
                        if stocksArr.count == 1  {
                            self.stock.description = stocksArr[0].description
                            self.stock.name = stocksArr[0].name
                        }
                    }
                case .failure(let error):
                    print(error)
                }
        }
    }

}
