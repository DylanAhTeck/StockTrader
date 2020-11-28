//
//  ContentView.swift
//  Stock Trader
//
//  Created by Dylan Ah Teck on 11/27/20.
//

import SwiftUI

struct ContentView: View {
    let title = "Stocks"
    var stocks = ["AAPL","MSFT","GOOG","W","SNAP"]
    var body: some View {
        NavigationView {
            List(stocks, id: \.self){
            item in
                
            VStack(alignment: .leading){
                Text(item).bold()
                Text("10.0 shares").font(.subheadline).foregroundColor(.secondary)
            }
            }
            .navigationTitle("Stocks")
        
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
