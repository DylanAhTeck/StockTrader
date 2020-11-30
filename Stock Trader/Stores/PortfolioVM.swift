//
//  PortfolioVM.swift
//  Stock Trader
//
//  Created by Dylan Ah Teck on 12/1/20.
//

import Foundation
import SwiftUI

class PortfolioVM: ObservableObject {
    
    @Published private var portfolioStocks : [Stock]
    //@AppStorage("portfolioStocks") var portfolioStocks: [Stock]
    static let saveKey = "PortfolioStocks"
    
    init() {
        if let data = UserDefaults.standard.data(forKey: Self.saveKey){
            if let decoded = try? JSONDecoder().decode([Stock].self, from: data){
                self.portfolioStocks = decoded
                return
            }
        }
        
        self.portfolioStocks = []
    }
    
    private func save() {
        if let encoded = try? JSONEncoder().encode(self.portfolioStocks) {
            UserDefaults.standard.set(encoded, forKey: Self.saveKey)
        }
    }
    
    func add(_ stock: Stock){
        portfolioStocks.append(stock)
        save()
    }
}
