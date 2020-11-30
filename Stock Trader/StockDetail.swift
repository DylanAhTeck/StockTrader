//
//  StockDetail.swift
//  Stock Trader
//
//  Created by Dylan Ah Teck on 11/28/20.
//

import SwiftUI
import Kingfisher

struct StockDetail: SwiftUI.View {
    
    
    var stock: Stock;
   // let stock = Stock(ticker: "MSFT", shares: 10.00, price: 111.20, change: -5.40)

    var body: some SwiftUI.View {
        ScrollView
        {
            VStack{
                StockOverviewView(stock: stock)
                PortfolioView()
                StatsView()
                //About
                AboutView()
                
                //News
                NewsView()
            }.navigationTitle(stock.ticker)//.padding(.leading)
         
        }
    }
}

struct StockDetail_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        NavigationView{
            StockDetail(stock: Stock(ticker: "MSFT", name: "Microsoft Corporation", shares: 10.00, price: 111.20, change: -5.40))
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
    var body: some SwiftUI.View {
        Text("Detail")
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
                        DetailView()
                    }
                }
            }.padding(.leading)
    }
}

struct StatsView: SwiftUI.View {
    let statKeys = ["last", "Open Price", "High", "Low", "Mid", "Volume", "Bid Price"]
    
    let data = ["last": 12, "Open Price": 4, "High": 2, "Low": 34.2, "Mid": 32.2,
                "Volume": 12,"Bid Price": 12]
    
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
                        ForEach(statKeys, id: \.self){
                            statKey in
                            
                            let key = statKey != "last" ? statKey : "Current Price"
                            let value = String(format: "%.2f", data[statKey, default: 0.0])
                            
                            Text("\(key): \(value)")
                        }
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
    var news = [
        "Title": "Microsoft is extending it's remote",
        "Img": "img_url",
        "timestamp": "123",
        "source": "source"
    ]
    
    let test = [1,2,3]
    
    var body: some SwiftUI.View {
        Section() {
            HStack(){
                Text("News").font(.title2).padding(.leading)
                Spacer()
            }
            //Big News

            TopNewsView()
            Divider()
            //List {
            ForEach(test, id: \.self){
                color in
                NewsArticleView()
//            List {
            // }
            //                .onAppear() {
            //                    UITableView.appearance().backgroundColor = UIColor.clear
            //                    UITableViewCell.appearance().backgroundColor = UIColor.clear
            //                }
            // .listStyle(PlainListStyle())
            }
        }
    }
}

struct TopNewsView: SwiftUI.View {
    var body: some SwiftUI.View {
        VStack
        {
            KFImage(URL(string: "https://homepages.cae.wisc.edu/~ece533/images/arctichare.png")!)
                .resizable()
                .cancelOnDisappear(true)
                .aspectRatio(contentMode: .fill)
                .cornerRadius(15)
            HStack{
                Text("Business insider").font(.subheadline).bold().foregroundColor(.secondary)
                Text("19 days ago").font(.subheadline).foregroundColor(.secondary)
                Spacer()
            }
            
            Text("Microsoft is extending its remote-work policy to July 2021 'at the earliest' (MSFT)").bold()
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
    var body: some SwiftUI.View {
        HStack{
            VStack
            {
                HStack{
                    Text("Business insider").font(.subheadline).bold().foregroundColor(.secondary)
                    Text("19 days ago").font(.subheadline).foregroundColor(.secondary)
                    Spacer()
                }
                HStack{
                    Text("Microsoft is extending its remote work policy to July 2021 'at the earliest' (MSFT)").bold().lineLimit(3)
                    Spacer()
                }
            }
            
            KFImage(URL(string: "https://homepages.cae.wisc.edu/~ece533/images/arctichare.png")!)
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
