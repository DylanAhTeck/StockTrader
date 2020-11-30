//
//  Stats.swift
//  Stock Trader
//
//  Created by Dylan Ah Teck on 12/1/20.
//

import Foundation
import SwiftyJSON

struct Stats: Decodable, JSONable {
    var open: Float
    var last: Float
    var high: Float
    var low: Float
    var mid: Float
    var volume: Float
    var bidPrice: Float
    
    init(parameter: JSON){
        open = parameter["open"].floatValue
        last = parameter["last"].floatValue
        high = parameter["high"].floatValue
        low = parameter["low"].floatValue
        mid = parameter["mid"].floatValue
        volume = parameter["volume"].floatValue
        bidPrice = parameter["bidPrice"].floatValue
    }
    
    init(open: Float = 0.0, last: Float = 0.0, high: Float = 0.0, low: Float = 0.0, mid: Float = 0.0
    , volume: Float = 0.0, bidPrice: Float = 0.0){
        self.open = open
        self.last = last
        self.high = high
        self.low = low
        self.mid = mid
        self.volume = volume
        self.bidPrice = bidPrice
    }
}