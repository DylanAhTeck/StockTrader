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
    @State var searchText: String = ""

    @ObservedObject var searchBar: SearchBar = SearchBar()

    var body: some View {
        NavigationView {
           
            //List(stocks, id: \.self){
            List{
                //Date
                Text ("October 28, 2020").font(.title).bold().foregroundColor(.gray)
                
                Section(header: Text("Portfolio")) {
                    //ScrollMovies(type: .currentMoviesInTheater)
                    
                    //Net Worth
                    VStack(alignment: .leading){
                        Text("Net Worth").font(.title)
                        Text("19961.60").bold().font(.title)
                    }
                    ForEach(stocks.filter {
                                searchBar.searchText.isEmpty ||
                                    $0.localizedStandardContains(searchBar.searchText)},
                            id: \.self){
                        eachStock in
                        VStack(alignment: .leading){
                               Text(eachStock).bold()
                               Text("10.0 shares").font(.subheadline).foregroundColor(.secondary)
                        }
                    }
                }
                Section(header: Text("Favorites")){
                    
                }
                
            }
            .navigationBarTitle("Stocks")
            .add(self.searchBar)
        
               
//            item in
//
//            VStack(alignment: .leading){
//                Text(item).bold()
//                Text("10.0 shares").font(.subheadline).foregroundColor(.secondary)
//            }
//            }
//            .navigationTitle("Stocks")
        
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
