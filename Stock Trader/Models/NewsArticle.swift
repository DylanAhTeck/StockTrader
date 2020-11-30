//
//  NewsArticle.swift
//  Stock Trader
//
//  Created by Dylan Ah Teck on 12/1/20.
//

import Foundation
import SwiftyJSON

struct NewsArticle: Decodable, JSONable, Hashable, Identifiable {
    var title: String
    var name: String
    var url: String
    var urlToImage: String
    var id = UUID()
    
    init(parameter: JSON){
        title = parameter["title"].stringValue
        name = parameter["source"]["name"].stringValue
        url = parameter["url"].stringValue
        urlToImage = parameter["urlToImage"].stringValue
    }
    
}
