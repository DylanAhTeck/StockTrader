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

struct Stock: Hashable, Identifiable, Decodable, JSONable {
    var id = UUID()
    let ticker: String
    let name: String
    let shares: Float
    let price: Float
    let change: Float
    
    init(parameter: JSON){
        ticker = parameter["ticker"].stringValue
        name = parameter["name"].stringValue
        shares = parameter["shares"].floatValue
        price = parameter["price"].floatValue
        change = parameter["change"].floatValue
    }
    
   // init(ticker: String, name: String, shares: Float, price: )
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
