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
    @State var searchText: String = ""
    init(stock: Stock){
        self.stock = stock
        stockVM = StockVM(stock: stock)
    }
    
    var body: some SwiftUI.View {
        ScrollView
        {
            VStack{
                StockOverviewView(stock: stock)
                PortfolioView()
                StatsView(stockVM: stockVM)
                //About
                AboutView()
                //News
                NewsView(stockVM: stockVM)
            }.navigationTitle(stock.ticker)//.padding(.leading)
         
        }
    }
}

struct StockDetail_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        NavigationView{
//            StockDetail(stock: Stock(ticker: "MSFT", name: "Microsoft Corporation", shares: 10.00, price: 111.20, change: -5.40)
//            )
        }
    }
}

struct StockOverviewView: SwiftUI.View {
    let stock: Stock
    var body: some SwiftUI.View {
        Section {
            HStack{
                Text(stock.name).font(.subheadline).foregroundColor(.secondary)
                Spacer()
            }
            HStack(alignment: .firstTextBaseline){
                Text("$\(String(format: "%.2f", stock.price))").bold().font(.largeTitle)
                Text("$(\(String(format: "%.2f", stock.change)))").font(.title2).foregroundColor(.green)
                Spacer()
            }
        }.padding(.leading)
    }
}

struct DetailView: SwiftUI.View {
    
    @Binding var showingDetail: Bool
    @State private var amount: String = ""
    
    @State private var lightsOn: Bool = false
    @State private var showToast: Bool = false
    
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
        
            Text("Trade Microsoft Corporation shares").bold()
            Spacer()
            HStack{
                TextField("0", text: $amount).font(.largeTitle)
                Text(Int(amount) ?? 0 > 1 ? "Shares" : "Share").font(.title)
            }.padding()
            HStack{
                Spacer()
                Text("x $204.72.share = $\(amount)")
            }
            Spacer()
            Text("$10368.42 available to buy MSFT")
            HStack{
                Button(action : {
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
        }.toast(isPresented: self.$showToast) {
            VStack {
                Text("Congratulations!").font(.largeTitle).bold().padding(.bottom)
                Text("You have successfully sold 1 share of MSFT")
            }.foregroundColor(.white)
        }
    }
}

struct Toast<Presenting, Content>: SwiftUI.View where Presenting: SwiftUI.View, Content: SwiftUI.View {
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
    func toast<Content>(isPresented: Binding<Bool>, content: @escaping () -> Content) -> some SwiftUI.View where Content: SwiftUI.View {
        Toast(
            isPresented: isPresented,
            presenter: { self },
            content: content
        )
    }
}

struct PortfolioView: SwiftUI.View {
    @State var showingDetail = false
    
    var body: some SwiftUI.View {
            VStack(alignment: .leading){
                Text("Portfolio").font(.title2)//.padding(.bottom, 5)
                HStack
                {
                    VStack(alignment: .leading){
                        Text("Shares Owned: 5.000").padding(1)
                        Text("Market Value: $1013.40").padding(1)
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
                        DetailView(showingDetail: $showingDetail)
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
    
    var body: some SwiftUI.View {
        Section{
            VStack(alignment: .leading){
                HStack(){
                    Text("About").font(.title2).padding(.bottom, 5)
                    Spacer()
                }
                HStack(){
                    Text("Amazon is guided by four principles: customer obsession rather than competitior focus, passion for invention, commitment to customers, etc.").lineLimit(moreText ? nil : 2)
                    Spacer()
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
            
            Text(newsArticle.title).bold()
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
            
            KFImage(URL(string: newsArticle.urlToImage)!)
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
