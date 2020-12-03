//
//  FavoritesVM.swift
//  Stock Trader
//
//  Created by Dylan Ah Teck on 12/3/20.
//

import Foundation
import SwiftUI
import Combine
import Alamofire
import SwiftyJSON

class FavoritesVM: ObservableObject {
    
    @Published var favoriteStocks : [Stock]
    //@AppStorage("portfolioStocks") var portfolioStocks: [Stock]
    private let url = "http://stocktraderbackend-env.eba-xpqeibcm.us-east-1.elasticbeanstalk.com"
    static let saveKey = "FavoriteStocks"
    var timer: Timer
    
    init() {
        self.favoriteStocks = []

        if let data = UserDefaults.standard.data(forKey: Self.saveKey){
            if let decoded = try? JSONDecoder().decode([Stock].self, from: data){
                self.favoriteStocks = decoded
            }
        }
        self.timer = Timer()
    }
    
    private func save() {
        if let encoded = try? JSONEncoder().encode(self.favoriteStocks) {
            UserDefaults.standard.set(encoded, forKey: Self.saveKey)
        }
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
        print("UPDATING FAVORITE STOCKS")
        self.favoriteStocks.indices.forEach {
            index in
            
            AF.request("\(self.url)/details/price/\(self.favoriteStocks[index].ticker)", method: .get, encoding: JSONEncoding.default)
                .responseJSON {
                (response) in
                    switch response.result {
                    case .success(let data):
                        let json = JSON(data)
                        if let statsArray = json.to(type: Stats.self){
                            let arr  = statsArray as! [Stats]
                            let stats = arr[0]
                            self.favoriteStocks[index].price = stats.last
                            self.favoriteStocks[index].change = stats.last - stats.prevClose
                        }
                    case .failure(let error):
                        print(error)
                    }
            }
        }
    }
    
    func add(_ stock: Stock){
        favoriteStocks.append(stock)
        updateStocks()
        save()
    }
    
    func remove(_ stock: Stock){
        if let idx = favoriteStocks.firstIndex(where: { $0.ticker == stock.ticker }) {
            favoriteStocks.remove(at: idx)
            save()
        }
    }
    
    func toggleStock(stock: Stock){
        stock.isFavorite.toggle()
        if(stock.isFavorite){
            self.add(stock)
        }
        else {
            self.remove(stock)
        }
    }
    
    func setFavorite(stock: Stock){
        if favoriteStocks.firstIndex(where: { $0.ticker == stock.ticker }) != nil {
            stock.isFavorite = true
        }
        else {
            stock.isFavorite = false
        }
    }
}


