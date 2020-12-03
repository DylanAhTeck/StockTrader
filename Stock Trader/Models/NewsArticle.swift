//
//  NewsArticle.swift
//  Stock Trader
//
//  Created by Dylan Ah Teck on 12/1/20.
//

import Foundation
import SwiftyJSON

class NewsArticle: Decodable, JSONable, Identifiable {
    static func == (lhs: NewsArticle, rhs: NewsArticle) -> Bool {
        lhs.url == rhs.url
    }
    
    var title: String
    var name: String
    var url: String
    var urlToImage: String
    var daysAgo: Int
    var publishedAt: String
    var id = UUID()
    
    required init(parameter: JSON){
        title = parameter["title"].stringValue
        name = parameter["source"]["name"].stringValue
        url = parameter["url"].stringValue
        urlToImage = parameter["urlToImage"].stringValue
        publishedAt = parameter["publishedAt"].stringValue
        daysAgo = 0
    }
    
}
