//
//  ContentView.swift
//  Stock Trader
//
//  Created by Dylan Ah Teck on 11/27/20.
//

import SwiftUI

struct ContentView: View {
    let title = "Stocks"
    
    var stocks: [Stock] = [
        Stock(ticker: "AAPL", name: "Aaple", shares: 10.00, price: 111.20, change: -5.40),
        Stock(ticker: "GOOG",  name: "Aaple",shares: 10.00, price: 111.20, change: -5.40),
        Stock(ticker: "W",  name: "Aaple", shares: 10.00, price: 111.20, change: -5.40),
        Stock(ticker: "MSFT", name: "Aaple", shares: 10.00, price: 111.20, change: -5.40)
    ]
    
    @State var searchText: String = ""
    @ObservedObject var searchBar: SearchBar = SearchBar()
    
    var body: some View {
        NavigationView {
            List{
                //Date
                Text (Date(), style: .date).font(.title).bold().foregroundColor(.gray)
                SectionView(title: "Portfolio", stocks: stocks, searchBar: searchBar)
                SectionView(title: "Favorites", stocks: stocks, searchBar: searchBar)
                ListFooter()
            }
            .navigationBarTitle("Stocks")
            .add(self.searchBar)
        
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct ListFooter: View {
    var body: some View {
        //Footer text
        Text("Powered by Tiingo")
            .font(.footnote)
            .foregroundColor(.secondary)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
            .onTapGesture
            {
                let url = URL.init(string: "https://www.tiingo.com")
                guard let tiingoURL = url, UIApplication.shared.canOpenURL(tiingoURL) else { return }
                UIApplication.shared.open(tiingoURL)
            }
    }
}

struct StockCell: View {
    var stock: Stock
    var body: some View {
        NavigationLink(destination: StockDetail(stock: stock))
        {
            VStack(alignment: .leading){
                Text(stock.ticker).bold()
                Text("\(String(format: "%.2f", stock.shares)) shares").font(.subheadline).foregroundColor(.secondary)
            }
            Spacer()
            VStack(alignment: .trailing){
                Text(String(format: "%.2f", stock.price)).bold()
                Text(String(format: "%.2f", stock.change)).font(.subheadline).foregroundColor(.red)
            }
        }
    }
}

struct SectionView: View {
    let title: String
    let stocks: [Stock]
    @ObservedObject var searchBar: SearchBar
    var body: some View {
        Section(header: Text(title)) {
            //ScrollMovies(type: .currentMoviesInTheater)
            //Net Worth
            if(title == "Portfolio"){
                VStack(alignment: .leading){
                    Text("Net Worth").font(.title)
                    Text("19961.60").bold().font(.title)
                }
            }
            ForEach(stocks.filter {
                        searchBar.searchText.isEmpty ||
                            $0.ticker.localizedStandardContains(searchBar.searchText)},
                    id: \.self){
                stock in
                StockCell(stock: stock)
            }
        }
    }
}
