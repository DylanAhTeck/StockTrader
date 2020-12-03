//
//  Stock.swift
//  Stock Trader
//
//  Created by Dylan Ah Teck on 11/28/20.
//

import Foundation
import SwiftyJSON

protocol JSONable {
    init?(parameter: JSON)
}

class Stock: Hashable, Identifiable, JSONable, Equatable, ObservableObject, Codable {
    
    static func == (lhs: Stock, rhs: Stock) -> Bool {
        lhs.ticker == rhs.ticker
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    var id = UUID()
    var ticker: String = ""
    var name: String = ""
    var shares: Float = 0.0
    @Published var price: Float = 0.0
    @Published var change: Float = 0.0
    var description: String = ""
    var isFavorite: Bool = false
    
    required init(parameter: JSON){
        ticker = parameter["ticker"].stringValue
        name = parameter["name"].stringValue
        shares = parameter["shares"].floatValue
        price = parameter["price"].floatValue
        change = parameter["change"].floatValue
        description = parameter["description"].stringValue
    }
    
    required init(from decoder: Decoder) throws {
           let container = try decoder.container(keyedBy: CodingKeys.self)
           ticker = try container.decode(String.self, forKey: .ticker)
           name = try container.decode(String.self, forKey: .name)
            shares = try container.decode(Float.self, forKey: .shares)
            price = try container.decode(Float.self, forKey: .price)
            change = try container.decode(Float.self, forKey: .change)
            description = try container.decode(String.self, forKey: .description)
            isFavorite = try container.decode(Bool.self, forKey: .isFavorite)

       }

       func encode(to encoder: Encoder) throws {
           var container = encoder.container(keyedBy: CodingKeys.self)
           try container.encode(name, forKey: .name)
            try container.encode(ticker, forKey: .ticker)
            try container.encode(shares, forKey: .shares)
            try container.encode(price, forKey: .price)
            try container.encode(change, forKey: .change)
            try container.encode(description, forKey: .description)
            try container.encode(isFavorite, forKey: .isFavorite)

       }
    
    enum CodingKeys: String, CodingKey{
        case ticker
        case name
        case shares
        case price
        case change
        case description
        case isFavorite
    }
    
    init(){
        
    }
 
}

extension JSON {
    func to<T>(type: T?) -> Any? {
        if let baseObj = type as? JSONable.Type {
            if self.type == .array {
                var arrObject: [Any] = []
                for obj in self.arrayValue {
                    let object = baseObj.init(parameter: obj)
                    arrObject.append(object!)
                }
                return arrObject
            } else {
                let object = baseObj.init(parameter: self)
                return [object!]
            }
        }
        return nil
    }
}
