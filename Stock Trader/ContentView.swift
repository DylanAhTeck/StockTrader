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
//        Stock(ticker: "AAPL", name: "Aaple", shares: 10.00, price: 111.20, change: -5.40),
//        Stock(ticker: "GOOG",  name: "Aaple",shares: 10.00, price: 111.20, change: -5.40),
//        Stock(ticker: "W",  name: "Aaple", shares: 10.00, price: 111.20, change: -5.40),
//        Stock(ticker: "MSFT", name: "Aaple", shares: 10.00, price: 111.20, change: -5.40)
    ]
    
    @State var searchText: String = ""
    @ObservedObject var searchBar: SearchBar = SearchBar()
    @ObservedObject var favoritesVM: FavoritesVM = FavoritesVM()
    @ObservedObject var portfolioVM: PortfolioVM = PortfolioVM()

    var body: some View {
        NavigationView {
            List{
                if(searchBar.searchText.count > 0){
                    SearchView(searchBar: searchBar, favoritesVM: favoritesVM, portfolioVM: portfolioVM)
                }
                else {
                    //Date
                    Text (Date(), style: .date).font(.title).bold().foregroundColor(.gray)
                    SectionView(title: "Portfolio", stocks: $portfolioVM.portfolioStocks, searchBar: searchBar,
                                favoritesVM: favoritesVM, portfolioVM: portfolioVM)
                    SectionView(title: "Favorites", stocks: $favoritesVM.favoriteStocks, searchBar: searchBar, favoritesVM: favoritesVM, portfolioVM: portfolioVM)
                    ListFooter()
                }
            }
            .navigationBarTitle("Stocks")
            .add(self.searchBar)
            .onAppear{
            favoritesVM.startUpdates()
            portfolioVM.startUpdates()
            }
            .onDisappear{
                favoritesVM.stopUpdates()
                portfolioVM.stopUpdates()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(favoritesVM: FavoritesVM())
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
   // @Binding var stock: Stock
    @ObservedObject var stock: Stock
    @ObservedObject var favoritesVM: FavoritesVM
    @ObservedObject var portfolioVM: PortfolioVM
    //var index: Int
    var body: some View {
        NavigationLink(destination: StockDetail(stock: stock, favoritesVM: favoritesVM, portfolioVM: portfolioVM))
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

struct SearchCell: View {
    var stock: Stock
    @ObservedObject var favoritesVM: FavoritesVM
    @ObservedObject var portfolioVM: PortfolioVM

    var body: some View {
        NavigationLink(destination: StockDetail(stock: stock, favoritesVM: favoritesVM, portfolioVM: portfolioVM))
        {
            VStack(alignment: .leading){
                Text(stock.ticker).bold()
                Text("\(stock.name)").font(.subheadline).foregroundColor(.secondary)
            }
        }
    }
}

struct SearchView: View {
    
    @ObservedObject var searchBar: SearchBar
    @ObservedObject var favoritesVM: FavoritesVM
    @ObservedObject var portfolioVM: PortfolioVM

    var body: some View {
        ForEach(searchBar.stocks,
                    id: \.self){
                stock in
                SearchCell(stock: stock, favoritesVM: favoritesVM, portfolioVM: portfolioVM)
            }
        }
}

struct SectionView: View {
    let title: String
    @Binding var stocks: [Stock]
    @ObservedObject var searchBar: SearchBar
    @ObservedObject var favoritesVM: FavoritesVM
    @ObservedObject var portfolioVM: PortfolioVM

    var body: some View {
        Section(header: Text(title)) {
            //ScrollMovies(type: .currentMoviesInTheater)
            //Net Worth
            if(title == "Portfolio"){
                VStack(alignment: .leading){
                    Text("Net Worth").font(.title)
                    
                    Text(String(format: "%.2f", portfolioVM.netWorth)).bold().font(.title)
                }
                
                ForEach(portfolioVM.portfolioStocks,
                        id: \.self){
                    stock in
                    StockCell(stock: stock, favoritesVM: favoritesVM, portfolioVM: portfolioVM)
                }
            }

            else {
                ForEach(favoritesVM.favoriteStocks,
                        id: \.self){
                    stock in
                    StockCell(stock: stock, favoritesVM: favoritesVM, portfolioVM: portfolioVM)
                }
            }

        }
    }
}
