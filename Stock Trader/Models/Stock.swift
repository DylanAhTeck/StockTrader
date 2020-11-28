//
//  Stock.swift
//  Stock Trader
//
//  Created by Dylan Ah Teck on 11/28/20.
//

import Foundation

struct Stock: Hashable {
    let ticker: String
    let name: String
    let shares: Float
    let price: Float
    let change: Float
}
