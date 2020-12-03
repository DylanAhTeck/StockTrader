//
//  PortfolioVM.swift
//  Stock Trader
//
//  Created by Dylan Ah Teck on 12/1/20.
//

import Foundation
import SwiftUI
import Combine
import Alamofire
import SwiftyJSON

class PortfolioVM: ObservableObject {
    
    @Published var portfolioStocks : [Stock]
    private let url = "http://stocktraderbackend-env.eba-xpqeibcm.us-east-1.elasticbeanstalk.com"
    static let saveKey = "PortfolioStocks"
    @Published var netWorth: Float
    var timer: Timer

    init() {
        self.portfolioStocks = []
        self.netWorth = 20000
        self.timer = Timer()
        
        if let data = UserDefaults.standard.data(forKey: Self.saveKey){
            if let decoded = try? JSONDecoder().decode([Stock].self, from: data){
                self.portfolioStocks = decoded
                self.calculateNetWorth()
            }
        }
        
        //let date = Date()
       // let timer = Timer(fireAt: date, interval: 15, target: self, selector: #selector(self.updateStocks), userInfo: nil, repeats: true)
       // RunLoop.main.add(timer, forMode: .common)
       // timer.
   
    }
    
    func startUpdates(){
        let date = Date()
        self.timer = Timer(fireAt: date, interval: 15, target: self, selector: #selector(self.updateStocks), userInfo: nil, repeats: true)
        RunLoop.main.add(self.timer, forMode: .common)
    }
    
    func stopUpdates(){
        self.timer.invalidate()
    }
    
    @objc func updateStocks(){
        print("UPDATING PORTFOLIO STOCKS")
        self.portfolioStocks.indices.forEach {
            index in
            
            AF.request("\(self.url)/details/price/\(self.portfolioStocks[index].ticker)", method: .get, encoding: JSONEncoding.default)
                .responseJSON {
                (response) in
                    switch response.result {
                    case .success(let data):
                        let json = JSON(data)
                        if let statsArray = json.to(type: Stats.self){
                            let arr  = statsArray as! [Stats]
                            let stats = arr[0]
                            self.portfolioStocks[index].price = stats.last
                            self.portfolioStocks[index].change = stats.last - stats.prevClose
                        }
                    case .failure(let error):
                        print(error)
                    }
            }
        }
    }
    
    private func save() {
        if let encoded = try? JSONEncoder().encode(self.portfolioStocks) {
            UserDefaults.standard.set(encoded, forKey: Self.saveKey)
        }
    }
    
    func add(_ stock: Stock){
        portfolioStocks.append(stock)
        updateStocks()
        save()
    }
    
    func remove(_ stock: Stock){
        if let idx = portfolioStocks.firstIndex(where: { $0.ticker == stock.ticker }) {
            portfolioStocks.remove(at: idx)
            save()
        }
    }
    
    func calculateNetWorth(){
        self.netWorth = 20000
    }
    
    func buy(){
        
    }
    func sell(){
        
    }
}
