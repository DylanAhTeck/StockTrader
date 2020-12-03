//
//  FavoritesVM.swift
//  Stock Trader
//
//  Created by Dylan Ah Teck on 12/3/20.
//

import Foundation
import SwiftUI

class FavoritesVM: ObservableObject {
    
    @Published var favoriteStocks : [Stock]
    //@AppStorage("portfolioStocks") var portfolioStocks: [Stock]
    static let saveKey = "FavoriteStocks"
    
    init() {
        if let data = UserDefaults.standard.data(forKey: Self.saveKey){
            if let decoded = try? JSONDecoder().decode([Stock].self, from: data){
                self.favoriteStocks = decoded
                return
            }
        }
        
        self.favoriteStocks = []
    }
    
    private func save() {
        if let encoded = try? JSONEncoder().encode(self.favoriteStocks) {
            UserDefaults.standard.set(encoded, forKey: Self.saveKey)
        }
    }
    
    func add(_ stock: Stock){
        favoriteStocks.append(stock)
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


