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

struct Stock: Hashable, Identifiable, Codable, JSONable {
    var id = UUID()
    var ticker: String = ""
    var name: String = ""
    var shares: Float = 0.0
    var price: Float = 0.0
    var change: Float = 0.0
    var description: String = ""
    
    init(parameter: JSON){
        ticker = parameter["ticker"].stringValue
        name = parameter["name"].stringValue
        shares = parameter["shares"].floatValue
        price = parameter["price"].floatValue
        change = parameter["change"].floatValue
        description = parameter["description"].stringValue
    }
    
    enum CodingKeys: String, CodingKey{
        case ticker
        case name
        case shares
        case price
        case change
        case description
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
