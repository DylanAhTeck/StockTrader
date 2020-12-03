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
    private let url = "http://traderbackend-env.eba-mmcgukdc.us-west-1.elasticbeanstalk.com"
    static let saveKey = "PortfolioStocks"
    static let networthKey = "NetWorth"

    @Published var netWorth: Float
    @Published var availableFunds: Float
    
    var timer: Timer

    init() {
        self.portfolioStocks = []
        self.netWorth = 20000
        self.timer = Timer()
        self.availableFunds = 20000
        
        if let data = UserDefaults.standard.data(forKey: Self.saveKey){
            if let decoded = try? JSONDecoder().decode([Stock].self, from: data){
                self.portfolioStocks = decoded
            }
        }
        
        if let data = UserDefaults.standard.data(forKey: Self.networthKey){
            if let decoded = try? JSONDecoder().decode(Float.self, from: data){
                self.netWorth = decoded
            }
        }
        
        self.calculateNetWorth()

        
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
        print("STOP PORTFOLIO UPDATE")
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
    
    func move(from source: IndexSet, to destination: Int){
        self.portfolioStocks.move(fromOffsets: source, toOffset: destination)
        save()
    }
    
    func update(_ stock: Stock){
        remove(stock)
        add(stock)
    }
    
    func calculateNetWorth(){
        var stockWorth: Float = 0
        self.portfolioStocks.forEach{
            stock in
            stockWorth += stock.price * stock.shares
        }
        self.netWorth = stockWorth + self.availableFunds
    }
    
    func buy(stock: Stock, amount: Float){
        print(self.availableFunds)
        print(self.netWorth)
        
        print(stock.price)
        print(amount)
        let cost = amount * stock.price
        stock.shares += amount
        self.availableFunds = self.availableFunds - cost
        
        update(stock)
        calculateNetWorth()
        print("Bought \(amount) shares")
        print(self.availableFunds)
        print(self.netWorth)
    }
    
    func sell(stock: Stock, amount: Float){
        stock.shares = stock.shares - amount
        self.availableFunds += amount * stock.price
        
        update(stock)
        calculateNetWorth()
        print("Sold \(amount) shares")
    }
}
