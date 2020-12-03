//
//  StockDetail.swift
//  Stock Trader
//
//  Created by Dylan Ah Teck on 11/28/20.
//

import SwiftUI
import Kingfisher

struct StockDetail: SwiftUI.View {
    
    var stock: Stock
    @ObservedObject var stockVM: StockVM
    @State private var showFavoriteToast: Bool = false

    @ObservedObject var portfolioVM: PortfolioVM
    @ObservedObject var favoritesVM: FavoritesVM
    @State var searchText: String = ""
    init(stock: Stock, favoritesVM: FavoritesVM, portfolioVM: PortfolioVM){
        self.stock = stock
        self.favoritesVM = favoritesVM
        self.portfolioVM = portfolioVM
        stockVM = StockVM(stock: stock)
    }
    
    var body: some SwiftUI.View {
        ScrollView
        {
            VStack{
                StockOverviewView(stockVM: stockVM)
                PortfolioView(stockVM: stockVM, portfolioVM: portfolioVM)
                StatsView(stockVM: stockVM)
                //About
                AboutView(stockVM: stockVM)
                //News
                NewsView(stockVM: stockVM)
            }
            .navigationTitle(stock.ticker)//.padding(.leading)
            .navigationBarItems(trailing:
            Button(action: {
                favoritesVM.toggleStock(stock: stockVM.stock)
                
                    withAnimation {
                    self.showFavoriteToast = true
                    }
                }) {
                
                stockVM.stock.isFavorite ?
                    Image(systemName: "plus.circle.fill"):
                    Image(systemName: "plus.circle")
                
            }.padding()
            )
 
        }.toast(isPresented: self.$showFavoriteToast) {
            HStack {
                if(stockVM.stock.isFavorite) {
                    Text("Adding \(stockVM.stock.ticker) to Favorites")
                }
                else{
                    Text("Removing \(stockVM.stock.ticker) from Favorites")
                }
            }
        }
    }
}

struct StockDetail_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        NavigationView{
            StockDetail(stock: Stock(), favoritesVM: FavoritesVM(), portfolioVM: PortfolioVM())
        }
    }
}

struct StockOverviewView: SwiftUI.View {
    @ObservedObject var stockVM: StockVM
    var body: some SwiftUI.View {
        Section {
            HStack{
                Text(stockVM.stock.name).font(.subheadline).foregroundColor(.secondary)
                Spacer()
            }
            HStack(alignment: .firstTextBaseline){
                Text("$\(String(format: "%.2f", stockVM.stats.last))").bold().font(.largeTitle)
                Text("$(\(String(format: "%.2f", stockVM.stats.change)))").font(.title2).foregroundColor(stockVM.stats.change == 0 ? .gray : stockVM.stats.change < 0 ? .red : .green)
                Spacer()
            }
        }.padding(.leading)
    }
}

struct DetailView: SwiftUI.View {
    
    @Binding var showingDetail: Bool
    @State private var amount: String = ""
    
    @State private var isBuyTransaction: Bool = false
    @State private var showToast: Bool = false
    @ObservedObject var stockVM: StockVM
    @ObservedObject var portfolioVM: PortfolioVM

    var body: some SwiftUI.View {
        VStack{
            HStack{
                Button(action: {
                    self.showingDetail.toggle()
                }) {
                    Image(systemName: "xmark").foregroundColor(.black)
                }.padding()
                Spacer()
            }
        
            Text("Trade \(stockVM.stock.name) shares").bold()
            Spacer()
            HStack{
                TextField("0", text: $amount).font(.largeTitle)
                Text(Int(amount) ?? 0 > 1 ? "Shares" : "Share").font(.title)
            }.padding()
            HStack{
                Spacer()
                Text("x $\(String(format: "%.2f", stockVM.stats.last)) share = $\( String(format: "%.2f", (Float(amount) ?? 0) * stockVM.stats.last))")
            }
           
            Spacer()
            Text("$\(String(format: "%.2f", portfolioVM.availableFunds)) available to buy \(stockVM.stock.ticker)")
            HStack{
                Button(action : {
                    
                    
                    portfolioVM.buy(stock: stockVM.stock, amount: Float(amount) ?? 0)
                    self.isBuyTransaction = true
                    withAnimation {
                        self.showToast.toggle()
                    }
                }
                ){Text("Buy")}
                    .padding()
                    .frame(minWidth: 0, maxWidth:150)
                    .background(Color.green)
                    .foregroundColor(Color.white)
                    .cornerRadius(40)
                    .padding(.trailing)
                
                
                Button(action: {
                    
                    self.isBuyTransaction = false
                    withAnimation {
                        self.showToast.toggle()
                    }
                }
                ){Text("Sell")}
                    .padding()
                    .frame(minWidth: 0, maxWidth:150)
                    .background(Color.green)
                    .foregroundColor(Color.white)
                    .cornerRadius(40)
                    .padding(.trailing)
            }.padding()
        }.successToast(isPresented: self.$showToast) {
            VStack {
                Text("Congratulations!").font(.largeTitle).bold().padding(.bottom)
                
                if(isBuyTransaction){
                    Text("You have successfully bought \(amount) \((Float(amount) ?? 0) <= 1 ? "share" : "shares") of \(stockVM.stock.ticker)")
                }else {
                    Text("You have successfully sold \(amount) \((Float(amount) ?? 0) <= 1 ? "share" : "shares") of \(stockVM.stock.ticker)")
                }
                
            }.foregroundColor(.white)
        }
    }
}

struct SuccessToast<Presenting, Content>: SwiftUI.View where Presenting: SwiftUI.View, Content: SwiftUI.View {
    @Binding var isPresented: Bool
    let presenter: () -> Presenting
    let content: () -> Content
    let delay: TimeInterval = 2

    var body: some SwiftUI.View {

        return GeometryReader { geometry in
            
            ZStack(alignment: .bottom) {
                self.presenter()
                ZStack {
                    Rectangle()
                        .fill(Color.green).ignoresSafeArea(edges: /*@START_MENU_TOKEN@*/.bottom/*@END_MENU_TOKEN@*/)
                                        
                    VStack{
                        Spacer()
                        self.content()
                        Spacer()
                        
                        Button(action: {
                            withAnimation {
                                self.isPresented = false;
                            }
                        }){Text("Done")}
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .foregroundColor(.green)
                        .cornerRadius(40)
                        
                    }.padding()
                    
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
                .opacity(self.isPresented ? 1 : 0)
            }
        }
    }
}

extension SwiftUI.View {
    func successToast<Content>(isPresented: Binding<Bool>, content: @escaping () -> Content) -> some SwiftUI.View where Content: SwiftUI.View {
        SuccessToast(
            isPresented: isPresented,
            presenter: { self },
            content: content
        )
    }
    
    func toast<Content>(isPresented: Binding<Bool>, content: @escaping () -> Content) -> some SwiftUI.View where Content: SwiftUI.View {
           Toast(
               isPresented: isPresented,
               presenter: { self },
               content: content
           )
       }
}

struct Toast<Presenting, Content>: SwiftUI.View where Presenting: SwiftUI.View, Content: SwiftUI.View {
    @Binding var isPresented: Bool
    let presenter: () -> Presenting
    let content: () -> Content
    let delay: TimeInterval = 2

    var body: some SwiftUI.View {
        if self.isPresented {
            DispatchQueue.main.asyncAfter(deadline: .now() + self.delay) {
                withAnimation {
                    self.isPresented = false
                }
            }
        }

        return GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                self.presenter()
              
                ZStack {
                    Rectangle()
                        .fill(Color.gray)
                        .cornerRadius(30)
                    
                    VStack{
                        Spacer()
                        self.content().foregroundColor(.white)
                        Spacer()
                    }
                    
                }
                .frame(width: geometry.size.width/1.25, height: geometry.size.height/12)
                .opacity(self.isPresented ? 1 : 0)
            }
        }
    }
}

struct PortfolioView: SwiftUI.View {
    @State var showingDetail = false
    @ObservedObject var stockVM: StockVM
    @ObservedObject var portfolioVM: PortfolioVM
    
    var body: some SwiftUI.View {
            VStack(alignment: .leading){
                Text("Portfolio").font(.title2)//.padding(.bottom, 5)
                HStack
                {
                    VStack(alignment: .leading){
                        
                        Text("Shares Owned: \(String(format: "%.2f", stockVM.stock.shares))").padding(1)
                        Text("Market Value: $\(String(format: "%.2f", stockVM.stock.shares * stockVM.stock.price))").padding(1)
                    }
                    Spacer()
                    Button(action : {
                        self.showingDetail.toggle()
                    }
                    ){Text("Trade")}
                        .padding()
                        .frame(minWidth: 0, maxWidth:150)
                        .background(Color.green)
                        .foregroundColor(Color.white)
                        .cornerRadius(40)
                        .padding(.trailing)
                    .sheet(isPresented: $showingDetail){
                        DetailView(showingDetail: $showingDetail, stockVM: stockVM,
                                   portfolioVM: portfolioVM)
                    }
                }
            }.padding(.leading)
    }
}

struct StatsView: SwiftUI.View {
    @ObservedObject var stockVM: StockVM
    
    let rows = [
        GridItem(.flexible(minimum:35), spacing: 0, alignment:.leading),
        GridItem(.flexible(minimum:35), spacing: 0, alignment:.leading),
        GridItem(.flexible(minimum:35), spacing: 0, alignment:.leading)
       ]
    
    var body: some SwiftUI.View {
        Section{
            VStack(alignment: .leading){
                HStack(){
                    Text("Stats").font(.title2).padding(.bottom, 5)
                    Spacer()
                }
                ScrollView(.horizontal) {
                    LazyHGrid(rows: rows, alignment:.center, spacing: 20) {
                        Text("Current Price: \(String(format: "%.2f", stockVM.stats.last))")
                        Text("Open Price: \(String(format: "%.2f", stockVM.stats.open))")
                        Text("High: \(String(format: "%.2f", stockVM.stats.high))")
                        Text("Low: \(String(format: "%.2f", stockVM.stats.low))")
                        Text("Mid: \(String(format: "%.2f", stockVM.stats.mid))")
                        Text("Volume: \(String(format: "%.0f", stockVM.stats.volume))")
                        Text("Bid Price: \(String(format: "%.2f", stockVM.stats.bidPrice))")
                    }
                }
            }
        }.padding(.leading).padding(.trailing)
    }
}

struct AboutView: SwiftUI.View {
    @State var moreText = false
    @ObservedObject var stockVM: StockVM
    
    var body: some SwiftUI.View {
        Section{
            VStack(alignment: .leading){
                HStack(){
                    Text("About").font(.title2).padding(.bottom, 5)
                    Spacer()
                }
                HStack(){
                    Text(stockVM.stock.description)
                        .lineLimit(moreText ? nil : 2)
                        .fixedSize(horizontal: false, vertical: true)
                }
                HStack(){
                    Spacer()
                    Button(action: {
                        self.moreText.toggle()
                    }){Text(self.moreText ? "Show less" : "Show more..." ).font(.subheadline).foregroundColor(.secondary)}.padding(.trailing).padding(.top, 1)
                }
            }
        }.padding()
    }
}

struct NewsView: SwiftUI.View {
    
    @ObservedObject var stockVM: StockVM
    var body: some SwiftUI.View {
        Section() {
            HStack(){
                Text("News").font(.title2).padding(.leading)
                Spacer()
            }
            //Big News
            ForEach(stockVM.news.indices, id: \.self){
                index in
                if(index == 0){
                    TopNewsView(newsArticle: stockVM.news[index])
                    Divider()
                }
                else {
                    NewsArticleView(newsArticle: stockVM.news[index])
                }
                
            }
        }
    }
}

struct TopNewsView: SwiftUI.View {
    var newsArticle: NewsArticle
    var body: some SwiftUI.View {
        VStack
        {
            KFImage(URL(string: newsArticle.urlToImage)!)
                .resizable()
                .cancelOnDisappear(true)
                .aspectRatio(contentMode: .fill)
                .cornerRadius(15)
            HStack{
                Text(newsArticle.name).font(.subheadline).bold().foregroundColor(.secondary)
                Text("19 days ago").font(.subheadline).foregroundColor(.secondary)
                Spacer()
            }
            HStack{
                Text(newsArticle.title).bold()
                Spacer()
            }
           
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .contentShape(RoundedRectangle(cornerRadius: 15))
        .contextMenu {
            Button(action: {
            }) {
                Label("Open in Safari", systemImage: "safari")
            }
            
            Button(action: {
            }) {
                Label("Share on Twitter", systemImage: "square.and.arrow.up")
            }
        }
    }
}

struct NewsArticleView: SwiftUI.View {
    
    var newsArticle: NewsArticle
    var body: some SwiftUI.View {
        HStack{
            VStack
            {
                HStack{
                    Text(newsArticle.name).font(.subheadline).bold().foregroundColor(.secondary)
                    Text("19 days ago").font(.subheadline).foregroundColor(.secondary)
                    Spacer()
                }
                HStack{
                    Text(newsArticle.title).bold().lineLimit(3)
                    Spacer()
                }
            }
            
            KFImage(URL(string: newsArticle.urlToImage))
                .resizable()
                .cancelOnDisappear(true)
                .scaledToFill()
                //                        .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100, alignment: .center)
                .clipped()
                .cornerRadius(10)
        }.padding(.leading)
        .padding(.trailing)
        .background(Color.white)
        .cornerRadius(15)
        .contentShape(RoundedRectangle(cornerRadius: 15))
        .contextMenu {
            Button(action: {
            }) {
                Label("Open in Safari", systemImage: "safari")
            }
            
            Button(action: {
            }) {
                Label("Share on Twitter", systemImage: "square.and.arrow.up")
            }
        }.cornerRadius(15)
    }
}
